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
      contact = appl.contact_person

      body = prepare_body(appl,@mail_params[:body])
      logger.debug("Result: "+body)
      mailer_params = { :body => body ,:subject => subject }

      result = tool.deliver_mailing(FestivalMail, appl.contact_person, nil, @letterfile,  letterArray, mailer_params)  
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
