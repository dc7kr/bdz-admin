class CustomInfoMailController < AuthenticatedNonResourceController
  include PdfHelper
  include BulkMailHelper
  include UploadHelper

  def index
    authorize! :member, :edit
    @event_id = SecureRandom.uuid
  end

  def test
    authorize! :member, :edit

    respond_to do |format|
      format.html
    end
  end

  def template_test
    authorize! :member, :edit
    form_params = params[:custom_info_mail]

    date_prefix = Time.now.strftime '%Y%m%d'
    cur_year = Time.now.strftime '%Y'

    letterfile = form_params[:datafile]

    letter_file = storeUploadedFile(cur_year.to_s, letterfile.original_filename, letterfile) unless letterfile.nil?

    addressee = DummyAddress.new
    addressee.mglnr = '4711'
    addressee.company = 'Mandolinenverein HARMONIE 1931 e.V.'
    addressee.fullname = 'Karsten Richter'
    addressee.street = 'Turmstr. 65'
    addressee.city = 'Dinslaken'
    addressee.zip = '46539'
    addressee.country_code = 'CH'

    filled_template = customize_letter(date_prefix, cur_year.to_s, 'gs', addressee, 'TPL_TEST', letter_file)

    send_file(filled_template.full_path, filename: filled_template.relative_filename,
                                         type: 'application/octet-stream')
  end

  def kasitest
    authorize! :member, :edit
    @mail_params = { subject: 'Testsubj', body: 'This is a shiny testbody', event_id: 'TEST_EVENT' }
    @results = []

    @orchCount = 0
    @orchFailCount = 0
    @personCount = 0
    @personFailCount = 0
    orchestra = Orchestra.find(420)

    @err = nil
    begin
      TestMail.notify('blah@tiscali.de', @mail_params).deliver
      recordMailSuccess(mail_params[:event_id], orchestra, @mail_params[:subject])
      @orchCount += 1
    rescue StandardError
      recordMailFailure(mail_params[:event_id], orchestra, $!.to_s)

      @result = { err: $!, entity: orchestra, type: 'O' }
      @results.push(@result)
      @orchFailCount += 1
    end

    respond_to do |format|
      format.html
    end
  end

  def send_mail
    authorize! :member, :edit

    form_params = params[:custom_info_mail]

    letterfile = form_params[:datafile]
    attachment = form_params[:attachment]
    grp = form_params[:group]
    via_paper = form_params[:via_paper]

    event_id = form_params[:event_id]
    subject = form_params[:subject]
    body = form_params[:body]

    @mail_params = { subject: subject, body: body, event_id: event_id }

    if event_id.nil? or event_id.empty? or event_id.include? ' '
      respond_to do |format|
        format.html { render action: 'index', warning: 'custom_info_mail.event_id_invalid' }
      end
      return
    end

    cur_year = Time.now.year

    if letterfile.nil?
      Rails.logger.info('Letter mode disabled due to nil letterfile')
      via_paper = false
    else
      letter_file = storeUploadedFile(cur_year.to_s, letterfile.original_filename, letterfile)
      letter_hash = letter_file.instance_values
    end

    unless attachment.nil?
      attachment = storeUploadedFile(cur_year.to_s, attachment.original_filename, attachment)
      attachment_hash = attachment.instance_values
    end

    CustomInfoMailJob.perform_async(@current_user.id, letter_hash, attachment_hash, subject, body, event_id, grp,
                                    via_paper)

    respond_to do |format|
      format.html { redirect_to home_cron_path, notice: t('cron.custom_info_mail_success') }
    end
  end
end
