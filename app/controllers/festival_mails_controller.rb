class FestivalMailsController < AuthenticatedNonResourceController

  include BulkMailHelper
  include UploadHelper
  include FestivalMailsHelper

  def index
    authorize! :member, :edit
    respond_to do |format|
      format.html
    end
  end

  def reservation_invoices 
    authorize! :member, :edit
    respond_to do |format|
      format.html
    end
  end
  
  def send_reservation_invoices
    authorize! :member, :edit

    EventCardInvoiceMailsWorker.perform_async(@current_user.id, "ECINVOICE")

    respond_to do |format|
        format.html { redirect_to home_festival_data_path, :notice => t('festival_mail.reservation_invoice_success') }
    end
  end



  def invoices
    authorize! :member, :edit
    respond_to do |format|
      format.html
    end
  end

  def send_invoices
    authorize! :member, :edit

    FestivalInvoiceMailsWorker.perform_async(@current_user.id, "TLNINVOICE")

    respond_to do |format|
        format.html { redirect_to home_festival_data_path, :notice => t('festival_mail.invoice_success') }
    end
  end

  def send_mails
    authorize! :member, :edit
    @mail_params = params["festival_mail"] 
    @successCount=0
    @failCount=0
    @results = Hash.new
    logger.info("PARAMS")
    logger.info(@mail_params)
    @group = @mail_params["group"]
    datafile = @mail_params[:datafile]


    cur_year = Time.now.year

    @att_file=nil
    @att_data=nil

    @results = Array.new

    @event = @mail_params[:event_id]

    if ( datafile != nil) then
      @letterfile = storeUploadedFile(cur_year.to_s, datafile.original_filename, datafile)
    end

    @applicants = nil

    if (@group == 'FA')  then 
      @applicants = FestivalApplication.includes(:contact_person)
    elsif ( @group == 'FP') then
      @applicants = FestivalApplication.includes(:contact_person).where(:permission=>true)
    elsif ( @group == 'FR') then
      @applicants = FestivalApplication.includes(:contact_person).where(:permission=>true,:visitor_type=>'R')
    elsif ( @group == 'FS') then 
      @applicants = FestivalApplication.includes(:contact_person).where(:permission=>true, :visitor_type=>'V')
    elsif ( @group == 'FJ') then
      @applicants = FestivalApplication.includes(:contact_person).where(:permission=>true,:visitor_type=>'Y')
    elsif ( @group == 'FG') then
      @applicants = FestivalApplication.includes(:contact_person).where(:permission=>true, :visitor_type=>'G')
    elsif ( @group == 'FO') then
      @applicants = FestivalApplication.includes(:contact_person).where(:permission=>true, :visitor_type=>'O')
    else 
      logger.error("NO GROUP identified: "+@group)
    end

    subject = @mail_params[:subject]

    tool = MailingTool.new(cur_year.to_s,"gs",@event,subject);

    letterArray = Array.new

    @applicants.each do |appl|
      addressee = appl.contact_person.to_addressee

      body = prepare_body(appl,@mail_params[:body])
      logger.debug("Result: "+body)
      mailer_params = { :body => body ,:subject => subject }

      result = tool.deliver_mailing(FestivalMail, addressee, nil, @letterfile,  letterArray, mailer_params)  
      @results << result

      if result[:success]==true then
          @successCount+=1;
      else 
          @failCount+=1;
      end
    end

    respond_to do |format|
      format.html
    end
 end
end
