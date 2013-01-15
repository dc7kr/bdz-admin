class ReportSheetInputsController < ApplicationController
  before_filter :authorize, :except => [:login,:submit_login]

  include NotifyHelper  
  include UploadHelper
  include ReportSheetUploadHelper

  def authorize
	@sess_token = session[:report_sheet_input_token]
	@input_id = session[:report_sheet_input_id]

	url_id = params[:id].to_i
	
	if ( @sess_token == nil or @input_id != url_id) then
		redirect_to "/report_sheet_inputs/login" , :flash => { :error => t('report_sheet_input.login_first') } 
		return
	end

    @report_sheet_input = ReportSheetInput.find(session[:report_sheet_input_id])
#	if ( current_user ) then 
#		return
#	end
	if ( @report_sheet_input == nil ) then
		redirect_to "/report_sheet_inputs/login" , :flash => { :notice => t('report_sheet_input.not_found') }
		return
	end
	if ( @report_sheet_input.token != @sess_token ) then
		redirect_to "/report_sheet_inputs/login" , :flash => { :error => t('report_sheet_input.not_authorized') } 
		return
	end
  end

  def login 

		
		#session[:report_sheet_token] = params[:token]
  end

  def submit_login
		@report_sheet_input = ReportSheetInput.find_by_token(params[:token])

		if ( @report_sheet_input == nil ) then
			Rails.logger.warn('Invalid token: ')
			redirect_to :action=>:login, notice: 'Invalid token'
		else
			@orchestra = @report_sheet_input.orchestra
			session[:report_sheet_input_id]=@report_sheet_input.id
			session[:report_sheet_input_token]=params[:token]

			redirect_to step1_report_sheet_input_path(@report_sheet_input)
		end
			
  end


  # GET /report_sheet_inputs
  # GET /report_sheet_inputs.json
  def index
    @report_sheet_inputs = ReportSheetInput.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @report_sheet_inputs }
    end
  end

  # GET /report_sheet_inputs/1
  # GET /report_sheet_inputs/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report_sheet_input }
    end
  end

  # GET /report_sheet_inputs/new
  # GET /report_sheet_inputs/new.json
  def new
	@year = Time.now.year+1

	@orchestra = Orchestra.includes(:member).find(params[:orchestra_id])
    @report_sheet_input = ReportSheetInput.new_for_orchestra(@orchestra,@year)
	@report_sheet_input.save

    respond_to do |format|
      format.html { redirect_to @report_sheet_input, notice: 'Report sheet input was successfully created.' }
      format.json { render json: @report_sheet_input, status: :created, location: @report_sheet_input }
    end
  end

  # GET /report_sheet_inputs/1/edit
  def step1

    @report_sheet_input = ReportSheetInput.find(params[:id])
	@contacts = @report_sheet_input.orchestra.orchestra_contacts

  end

  # PUT
  def submit1
	@report_sheet_input = ReportSheetInput.find(params[:id])

    
    respond_to do |format|
      if @report_sheet_input.orchestra.update_attributes(params[:report_sheet_input][:orchestra]) and @report_sheet_input.report_sheet.update_attributes(params[:report_sheet_input][:report_sheet]) then
        format.html { redirect_to step2_report_sheet_input_path(@report_sheet_input), notice: t('report_sheet_input.save_success') }
        format.json { render json: @report_sheet_input, status: :created, location: step2_report_sheet_input_path(@report_sheet_input) }
      else
        format.html { render action: "step1" }
        format.json { render json: @report_sheet_input.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit2
	data = params[:report_sheet_input];

	@contacts = data["contact"] 

	@contacts.each do |idx,c|
		if ( c["id"] != "" ) then 
			oc = OrchestraContact.find(c["id"])
			if ( oc.orchestra_id == @report_sheet_input.orchestra.id ) then
				oc.update_attributes(c)
				#oc.save
				Rails.logger.warn(oc)
			else
				Rails.logger.warn('ID has been tampered with!: '+c["id"])
			end
		else
			if (c["last_name"].length >1) then
				oc = OrchestraContact.new(c)
				oc.orchestra_id = @report_sheet_input.orchestra_id
				oc.save
			end
		end
	end

    respond_to do |format|
        format.html { redirect_to step3_report_sheet_input_path(@report_sheet_input), notice: t('report_sheet_input.save_success') }
    end
  end
 
  def step2 
	@report_sheet_input = ReportSheetInput.find(params[:id])
	@contacts =  @report_sheet_input.orchestra.orchestra_contacts
	roles = OrchestraContact.roles

	@contact_hash = Hash.new

	@contacts.each do |c|
		@contact_hash[c.role]=c
	end

	roles.each do |r|
		if ( @contact_hash[r]==nil ) then
			contact = OrchestraContact.new
			contact.role = r
			@contact_hash[r] = contact
		end
	end
  end


  def step3
	@report_sheet_input = ReportSheetInput.includes([:orchestra]).find(params[:id])

	@orchestra = @report_sheet_input.orchestra

	@members = @orchestra.orchestra_members

	@year = @report_sheet_input.report_sheet.year

  end

		  def step4 
			@report_sheet_input = ReportSheetInput.includes([:orchestra]).find(params[:id])
			@report_sheet = @report_sheet_input.report_sheet

		  end

		  def submit4
			@report_sheet_input = ReportSheetInput.find(params[:id])
			@rs = @report_sheet_input.report_sheet

			age_categories = ReportSheet.age_categories
			ages = Hash.new

			age_categories.each do |c| 
				ages[c]=0
			end
			

			@report_sheet_input.orchestra.orchestra_members.each do |m|
				ages[m.age_category(@rs.year)]+=1
			end

			@rs.children = ages["C"];
			@rs.teens = ages["T"];
			@rs.youth = ages["Y"];
			@rs.adult = ages["A"];
			@rs.senior= ages["S"];
			@rs.save

			respond_to do |format|
				format.html { 
					if ( @rs.update_attributes(params[:report_sheet]) ) then 
						redirect_to finalize_report_sheet_input_path(@report_sheet_input), notice: t('report_sheet_input.save_success') 
					else 
						redirect_to step4_report_sheet_input_path(@report_sheet_input), :flash => { :error => t('report_sheet_input.save_error') } 
					end
				}
			end
		end

	def finalize
		@report_sheet_input = ReportSheetInput.find(params[:id])
		@rs = @report_sheet_input.report_sheet
		contact_array =  @report_sheet_input.orchestra.orchestra_contacts

		@contacts = Hash.new

		@members = OrchestraMember.where("orchestra_id = ?",@report_sheet_input.orchestra.id)

		@counts = {	
			"C"=>0,
			"T"=>0,
			"Y"=>0,
			"A"=>0,
			"S"=>0
		}
		
		@year = @rs.year

		@members.each do |m|
			if ( m.age(@year) < 15 ) then 
				@counts["C"]+=1
			elsif ( m.age(@year) <=18) then
				@counts["T"]+=1
			elsif ( m.age(@year) <=27) then
				@counts["Y"]+=1
			elsif ( m.age(@year) <=55) then
				@counts["A"]+=1
			else
				@counts["S"]+=1
			end
		end

		contact_array.each do |c|
			@contacts[c.role] = c
		end
			
		@roles = OrchestraContact.roles

		   
		@orchestration = Array.new
		if (@rs.zo) then 
			@orchestration.append "Zupforchester"
		end

		if ( @rs.zi_o) then
			@orchestration.append "Zitherorchester"
		end
				
		if ( @rs.go) then
			@orchestration.append "Gitarrenorchester"
		end

		if ( @rs.oz) then
			@orchestration.append "Andere"
		end
			

		respond_to do |format|
			format.html
		end
	 end

	  def confirm 
			@rsi = ReportSheetInput.includes(:orchestra).find(params[:id])
			@rs = @rsi.report_sheet
			if ( @rs.orchestra == nil ) then
				@rs.orchestra = @rsi.orchestra
				@rs.save

				# admin notify about new RS
				@users = admin_notify_users

   				@users.each do |user|
					AdminNotifier.new_report_sheet(user,@rs).deliver
       				Rails.logger.info 'sent to %s' % user.email
   				end
			end

			respond_to do |format|
				format.html
				format.pdf do
				pdf = ReportSheetInputPdf.new(@rsi, view_context)
				send_data pdf.render, filename: "meldebogen_#{@rsi.report_sheet.year}_#{@rsi.orchestra.mglnr}.pdf",
									  type: "application/pdf",
									  disposition: "inline"
				end
			end

		  end

		  # POST /report_sheet_inputs
		  # POST /report_sheet_inputs
		  # POST /report_sheet_inputs.json
	  def create
		@report_sheet_input = ReportSheetInput.new(params[:report_sheet_input])

		respond_to do |format|
		  if @report_sheet_input.save
				format.html { redirect_to @report_sheet_input, notice: 'Report sheet input was successfully created.' }
				format.json { render json: @report_sheet_input, status: :created, location: @report_sheet_input }
			  else
				format.html { render action: "new" }
				format.json { render json: @report_sheet_input.errors, status: :unprocessable_entity }
			  end
			end
		  end

		  # PUT /report_sheet_inputs/1
		  # PUT /report_sheet_inputs/1.json
		  def update
			@report_sheet_input = ReportSheetInput.find(params[:id])

			respond_to do |format|
			  if @report_sheet_input.update_attributes(params[:report_sheet_input])
				format.html { redirect_to @report_sheet_input, notice: 'Report sheet input was successfully updated.' }
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @report_sheet_input.errors, status: :unprocessable_entity }
			  end
			end
		  end

		  # POST
		  def upload
			@report_sheet_input = ReportSheetInput.find(params[:id])
			@orchestra = @report_sheet_input.orchestra

			prefix = @orchestra.mglnr.to_s+"_"+Time.now.year.to_s+"_"

			uploaded_file = DataFile.save(prefix, "/tmp",params[:datafile]) 

			datafile = params[:datafile]

			if ( datafile != nil) then
				@att_file = datafile.original_filename

				doc = open_report_spreadsheet(@att_file,uploaded_file)
				if ( doc == nil ) then
      	  			redirect_to step3_report_sheet_input_path(@report_sheet_input), :flash => { :error => t('orchestra.invalid_report_sheet_upload') } 
				else
					read_report(doc,@orchestra)
					if ( @error_count > 0 ) then 
   	     				redirect_to step3_report_sheet_input_path(@report_sheet_input), :flash => { :warning=> t('orchestra.report_sheet_upload_warning',:error => @error_count,:success => @success_count) } 
					else
   	     				redirect_to step3_report_sheet_input_path(@report_sheet_input), :flash => { :notice=> t('orchestra.report_sheet_upload_success',:success => @success_count) } 
					end
		end
	end
  end

  # DELETE /report_sheet_inputs/1
  # DELETE /report_sheet_inputs/1.json
  def destroy
    @report_sheet_input = ReportSheetInput.find(params[:id])
    @report_sheet_input.destroy

    respond_to do |format|
      format.html { redirect_to report_sheet_inputs_url }
      format.json { head :no_content }
    end
  end
end
