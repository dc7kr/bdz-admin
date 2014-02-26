class CustomInfoMailController < AuthenticatedNonResourceController

  include PDFHelper
  include BulkMailHelper
  include UploadHelper

  def index
    authorize! :member, :edit
  end

  def kasitest
    authorize! :member, :edit
    @mail_params =  { :subject => "Testsubj", :body=> "This is a shiny testbody", :event_id => "TEST_EVENT" }
    @results = Array.new

    @orchCount=0
    @orchFailCount=0
    @personCount=0
    @personFailCount=0
    orchestra = Orchestra.find(420)

    @err = nil
    begin
      TestMail.notify("blah@tiscali.de",@mail_params).deliver
      recordMailSuccess(mail_params[:event_id],orchestra, @mail_params[:subject])
      @orchCount=@orchCount+1
    rescue
      recordMailFailure(mail_params[:event_id],orchestra, $!.to_s)

      @result = { :err=>$!, :entity=>orchestra,:type =>"O"}
      @results.push(@result)
      @orchFailCount=@orchFailCount+1;
    end

    respond_to do |format|
      format.html
    end
  end
    
  def send_mail
    authorize! :member, :edit
    form_params = params[:email]

    letterfile = form_params[:datafile]
    attachment = form_params[:attachment]
    grp = form_params[:group]
    via_paper= form_params[:via_paper]

    event_id = form_params[:event_id]
    subject = form_params[:subject]
    body = form_params[:body]

    cur_year = Time.now.year


    if ( letterfile != nil) then
      letter_file = storeUploadedFile(cur_year.to_s, letterfile.original_filename, letterfile)
    end

    if ( attachment != nil) then
      attachment = storeUploadedFile(cur_year.to_s, attachment.original_filename, attachment)
    end

    CustomInfoMailWorker.perform_async(@current_user.id,letter_file,attachment, subject, body, event_id, grp, via_paper)

    respond_to do |format|
        format.html { redirect_to home_cron_path, :notice => t('cron.custom_info_mail_success') }
    end
  end
end
