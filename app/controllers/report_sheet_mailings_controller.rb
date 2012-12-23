class ReportSheetMailingsController < AuthenticatedNonResourceController

	include PDFHelper
	def gen_data
  		authorize! :index, Orchestra
		rs_year = params[:year].to_i

		if params[:year]== nil then
			rs_year = Time.now.year+1
		end

		@count = 0
		@orchestras = Orchestra.includes(:member)
		@orchestras.each do |o|
			@rsi = ReportSheetInput.for_orchestra_and_year(o,rs_year)
    		if ( @rsi == nil ) then
        		@rsi = ReportSheetInput.new_for_orchestra(o,rs_year)
    			@rsi.save
				@count+=1
    		end
		end

    	respond_to do |format|
      		format.html {
				render :text => "OK:Created "+@count.to_s+" Report sheet inputs."
				return
			}
    	end
	end

	def gen_mailings
  		authorize! :index, Orchestra

		@orchCount =0;
		@orchFailCount=0;
		@letterCount = 0;
		@results =  Array.new

		rs_year = nil
		if params[:year]==nil then
			rs_year = Time.now.year+1
		else
			rs_year = params[:year].to_i
		end

		event_id = "MB_"+rs_year.to_s

		if ( is_production? ) then
			@orchestras = Orchestra.includes(:member).where("members.mglnr=99999")
		else 
			@orchestras = Orchestra.includes(:member).where("members.mglnr=1045")
		end

		to_merge = Array.new
		@orchestras.each do |orchestra|
		@rsi = ReportSheetInput.for_orchestra_and_year(orchestra,rs_year)

		mailing_pdf = gen_anschreiben(orchestra,@rsi);

	   	@att_file = "Anschreiben_Meldebogen_"+rs_year.to_s+".pdf"
		pdf = File.new(mailing_pdf)
		@att_data = pdf.read
		pdf.close
		
		if (orchestra.email != nil ) then
				begin 
					ReportSheetInputMailer.notify(@rsi,rs_year,@att_file,@att_data).deliver
					recordMailSuccess(event_id,orchestra.id, "Meldebogen Anschreiben",mailing_pdf)
					@orchCount=@orchCount+1
				rescue
					recordMailFailure(event_id,orchestra.id,orchestra.email,$!)
					@result = { :err=>$!, :entity=>orchestra,:type =>"O"}
					@results.push(@result)
					@orchFailCount+=1
					# if mail fails we send a PDF via snail mail ;)
					to_merge << mailing_pdf
					recordLetter(event_id,orchestra.id,mailing_pdf)
				end
		else
			@letterCount+=1
			to_merge << mailing_pdf
		end
	end
	#	// TODO MERGE PDFS!!!
	end

  def recordMailSuccess(event_id,id,subject,filename)
	event = MemberEvent.newEmail(event_id,id,subject)
	event.filename=filename
	event.save
  end

  def recordMailFailure(event_id,id, email, result)
	event = MemberEvent.newFailedEmail(event_id,id,result.to_s)
	event.save
  end
  def recordLetter(event_id,id,filename)
	event = MemberEvent.newLetter(event_id,id,event_id)
	event.filename=filename
	event.save
  end
end
