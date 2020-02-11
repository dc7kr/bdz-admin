class Mgl::ReportSheetInputsController < ApplicationController
  before_filter :authorize, :except => [:login,:submit_login]

  include NotifyHelper  
  include UploadHelper
  include ReportSheetUploadHelper
  include CountryHelper
  helper ReportSheetInputsHelper

  def authorize
	@sess_token = session[:report_sheet_input_token]
	@input_id = session[:report_sheet_input_id]

	url_id = params[:id].to_i
	
	if ( @sess_token == nil or @input_id != url_id) then
    flash[:error ] =  t('report_sheet_input.login_first') 
		redirect_to url_for(:action=>:login)
		return
	end

    @report_sheet_input = ReportSheetInput.find(session[:report_sheet_input_id])
#	if ( current_user ) then 
#		return
#	end
	if ( @report_sheet_input == nil ) then
		redirect_to url_for(:action=>:login), :flash => { :notice => t('report_sheet_input.not_found') }
		return
	end
	if ( @report_sheet_input.token != @sess_token ) then
		redirect_to url_for(:action=>:login) , :flash => { :error => t('report_sheet_input.not_authorized') } 
		return
	end
  end

  def login 
		#session[:report_sheet_token] = params[:token]
    @mglnr = params[:mglnr]
    @token = params[:token]
    @dsgvo=false

  end

  def submit_login
		@report_sheet_input = ReportSheetInput.find_by_token(params[:token])
    
    @dsgvo = params[:dsgvo]
    if not @dsgvo then
      flash[:error] =  t('report_sheet_input.please_confirm_dsgvo')
			redirect_to :action=>:login
    elsif ( @report_sheet_input.nil? ) then
			Rails.logger.warn('Invalid token: ')
      flash[:error] =  t('report_sheet_input.invalid_token')
			redirect_to :action=>:login
		else
			@orchestra = @report_sheet_input.orchestra
      @orchestra.member.dsgvo=true
      @orchestra.member.dsgvo_date=Time.now
      @orchestra.member.save!
			session[:report_sheet_input_id]=@report_sheet_input.id
			session[:report_sheet_input_token]=params[:token]

			redirect_to :action=>:step1, :id=> @report_sheet_input
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

    if current_user != nil then
        @report_sheet_input.admin_flag=true
    else
      # looks strange but is correct! this is for NIL case and admin
      # flag not yet set to false... (if it is true we want it to stay true)
      if ( @report_sheet_input.admin_flag!=true) then
        @report_sheet_input.admin_flag=false
      end
    end
    @report_sheet_input.save
    
    respond_to do |format|
      if @report_sheet_input.orchestra.update(orchestra_params(params[:report_sheet_input])) and @report_sheet_input.report_sheet.update(report_sheet_params(params[:report_sheet_input])) then
        format.html { redirect_to :action => :step2, :id => @report_sheet_input, notice: t('report_sheet_input.save_success') }
        format.json { render json: @report_sheet_input, status: :created, location: url_for(:action=>:step2,:id=>@report_sheet_input) }
      else
        format.html { render action: "step1" }
        format.json { render json: @report_sheet_input.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit2
    data = params.require("report_sheet_input")

    #params[:report_sheet_input];

    @contacts = data["contact"] 

    @contacts.each do |idx,c|
      if ( c["id"] != "" ) then 
        oc = OrchestraContact.find(c["id"])
        if ( oc.orchestra_id == @report_sheet_input.orchestra.id ) then
          oc.update_attributes(contact_params(c))
          oc.save
          Rails.logger.warn("Created orchestra contact")
          Rails.logger.warn(oc)
        else
          Rails.logger.warn('ID has been tampered with!: '+c["id"])
        end
      else
        if (c["last_name"].length >1) then
          oc = OrchestraContact.new(contact_params(c))
          oc.orchestra_id = @report_sheet_input.orchestra_id
          oc.save
        end
      end
    end

    respond_to do |format|
        format.html { redirect_to :action=>:step3, :id=> @report_sheet_input, notice: t('report_sheet_input.save_success') }
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

	  @members = @orchestra.orchestra_members.order(["last_name, first_name"])

	  @year = @report_sheet_input.report_sheet.year


    @faultyMembers = 0 
    @validMembers = 0

    @members.each do |m|
      if m.valid? then
        @validMembers += 1 
      else
        @faultyMembers += 1
      end    
    end

  end

  def step4 
			@report_sheet_input = ReportSheetInput.includes([:orchestra]).find(params[:id])
			@report_sheet = @report_sheet_input.report_sheet

	end

  def submit4
			@report_sheet_input = ReportSheetInput.find(params[:id])
			@rs = @report_sheet_input.report_sheet

      @rs.update_from_orchestra_members(@report_sheet_input.orchestra.orchestra_members)


			respond_to do |format|
				format.html { 
					if @rs.update(report_sheet_params(params))  then 
						redirect_to url_for(:action=>:finalize,:id=>@report_sheet_input), notice: t('report_sheet_input.save_success') 
					else 
						redirect_to url_for(:action=>:step4,:id=>@report_sheet_input), :flash => { :error => t('report_sheet_input.save_error') } 
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
			elsif ( m.age(@year) <65) then
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

      cur_year = Time.now.strftime '%Y'
      event_id = "MB_#{@rs.year}_CONFIRM"

      tool = MailingTool.new(cur_year.to_s,"gs",event_id,"Bestaetigung Meldebogeneingabe",false);

      letterArray = Array.new
      mailer_params = { :rsi => @rsi }

			if ( @rs.orchestra == nil ) then
				@rs.orchestra = @rsi.orchestra
        @rs.report_date = Time.now
				@rs.save

        if @rs.errors.any? then
            @rs.errors.each do |attr,msg|
            logger.error("#{attr} - #{msg}")
          end
        end


				# admin notify about new RS
				#@users = User.for_admin_notify

   			#	@users.each do |user|
			  # 		AdminNotifier.new_report_sheet(user,@rs).deliver
       	#	Rails.logger.info 'sent to %s' % user.email
   			#	end
			end

      mglnr = @rsi.orchestra.member.mglnr

      datePrefix = Time.now.strftime("%Y%m%d%H%M%S")
      filename = "#{datePrefix}_meldebogen_#{@rsi.report_sheet.year}_#{mglnr}.pdf"
		  pdf = ReportSheetInputPdf.new(@rsi, view_context)
      pdf_file = MailingFile.new(filename, filename, Time.now.strftime("%Y"))
      pdf.render_file pdf_file.full_path

			respond_to do |format|
				format.html do
          result = tool.deliver_mailing(ReportSheetConfirmationMail, @rsi.orchestra.to_addressee,  pdf_file,  nil, nil, mailer_params)
        end
				format.pdf do
          Rails.logger.debug "Sending PDF: #{pdf_file.full_path}"
				  send_file pdf_file.full_path, filename: "meldebogen_#{@rsi.report_sheet.year}_#{mglnr}.pdf",
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
		if ( current_user != nil ) then
			@report_sheet_input.admin_flag=true
		else
			@report_sheet_input.admin_flag=false
		end

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

  def dowmload_current_member_list
    @report_sheet_input = ReportSheetInput.find(params[:id])
    @orchestra = @report_sheet_input.orchestra
    sheet = @orchestra.orchestra_members_sheet

  end

  # POST
  def upload
    @report_sheet_input = ReportSheetInput.find(params[:id])
    @orchestra = @report_sheet_input.orchestra

    datafile = params[:datafile]

    mglnr = @orchestra.member.mglnr

    prefix = mglnr.to_s+"_"+Time.now.year.to_s+"_"

    if (datafile == nil ) then
          redirect_to url_for(:action=>:step3,:id=>@report_sheet_input), :flash => { :error => t('report_sheet_input.no_file_selected') } 
      return
    end

    uploaded_file = DataFile.save(prefix, "/tmp",params[:datafile]) 


    if ( datafile != nil) then
      @att_file = datafile.original_filename

      doc = open_report_spreadsheet(@att_file,uploaded_file)

      if ( doc == nil ) then
            redirect_to url_for(:action=>:step3,:id=>@report_sheet_input), :flash => { :error => t('report_sheet_input.invalid_upload') } 
      else
        if not verify_report(doc) then
          redirect_to url_for(:action=>:step3,:id=>@report_sheet_input), :flash => { :error => t('orchestra.invalid_report_sheet_upload')} 
          return
        end

        # delete previous entries

        @orchestra.orchestra_members.destroy_all

        read_report(doc,@orchestra)

        if ( @error_count > 0 ) then 
            redirect_to url_for(:action=>:step3,:id=>@report_sheet_input), :flash => { :warning=> t('orchestra.report_sheet_upload_warning',:error => @error_count,:success => @success_count) } 
        else
            redirect_to url_for(:action=>:step3,:id=>@report_sheet_input), :flash => { :notice=> t('orchestra.report_sheet_upload_success',:success => @success_count) } 
        end
      end
    end
  end


  def delete_members
	  @report_sheet_input = ReportSheetInput.find(params[:id])
	  @report_sheet_input.orchestra.orchestra_members.delete_all

    respond_to do |format|
        format.html { redirect_to url_for(:action=>:step3,:id=>@report_sheet_input), notice: t('report_sheet_input.member_delete_success') }
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

  def step1_params
    params.require(:report_sheet_input).permit()
  end

  def step2_params
    params.require(:report_sheet_input).permit()
  end
  
  def step3_params
    params.require(:report_sheet_input).permit()
  end

  def step4_params
    params.require(:report_sheet_input).permit()
  end

  private
  def report_sheet_params root
    root.require(:report_sheet).permit(:id, :uv,
       :azubi_child, :azubi_teens, :azubi_youth, :azubi_adult, :azubi_senior, :passive, :supporters,
       :child_ens, :youth_ens, :adult_ens, :senior_ens, :other_ens,
        :zo, :zi_o, :go, :oz )
  end

  def orchestra_params root
    root.require(:orchestra).permit( :orchName, :gruendung, :member_attributes => [ :id, :title, :anrede, :vorname, :name, :strasse, :plz, :ort, :email, :za, :zahler, :telefon, :fax, :bic, :iban, :country_code ]  )
  end

  def contact_params(params)
    params.permit(OrchestraContact.permitted_params)
  end
end
