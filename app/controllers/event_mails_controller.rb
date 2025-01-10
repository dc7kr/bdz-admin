class EventMailsController < AuthenticatedNonResourceController
  include BulkMailHelper
  include UploadHelper

  def index
    authorize! :member, :edit
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
    @mail_params = params[:email]

    orchestra = false
    em = false
    test = false
    festival = false

    @grp = @mail_params[:group]
    if @grp == 'A'
      orchestra = true
      em = true
    elsif @grp == 'O'
      orchestra = true
    elsif @grp == 'E'
      em = true
    elsif @grp == 'T'
      test = true
    elsif @grp == 'F'
      festival = true
    elsif @grp == 'FP'
      festival = true
      permitted = true
    elsif @grp == 'FS'
      true
    elsif @grp == 'FJ'
      festival_youth = true
    elsif @grp == 'FG'
      festival_guests = true
    end

    @testCount = 0
    @testFailCount = 0
    @orchCount = 0
    @orchFailCount = 0

    @festivalCount = 0
    @festivalFailCount = 0
    @permittedCount = 0
    @permittedFailCount = 0
    @personCount = 0
    @personFailCount = 0
    @results = []

    datafile = @mail_params[:datafile]
    @att_file = nil
    @att_data = nil

    @event = @mail_params[:event_id]

    unless datafile.nil?
      @att_file = datafile.original_filename
      @att_data = readDataFile(@mail_params)
    end

    if test
      @emails = ['thomas.kronenberger@bdz-online.de', 'someone@gibtsnicht.kasi-net.org',
                 'theresa.brandt@bdz-online.de', 'dominik.hackner@bdz-online.de', 'karsten.richter@bdz-online.de']
      # @emails = [ 'karsten.richter@gmail.com', 'someone@gibtsnicht.kasi-net.org', 'karsten.richter@bdz-online.de']
      @emails.each do |email|
        CustomInfoMail.notify(email, params[:email], @att_file, @att_data).deliver
        @testCount += 1
      rescue StandardError
        @result = { err: $!, entity: email, type: 'T' }
        @results.push(@result)
        @testFailCount += 1
      end
    end

    if orchestra
      @orchestras = Orchestra.mailForEvent(@event)

      @orchestras.each do |orchestra|
        if is_mail_blacklisted?(orchestra.email)
          recordMailFailure(params[:event_id], orchestra, 'blacklisted')

          @result = { err: 'blacklisted', entity: orchestra, type: 'O' }
          @results.push(@result)
          @orchFailCount += 1
        else
          CustomInfoMail.notify(orchestra.email, params[:email], @att_file, @att_data).deliver
          recordMailSuccess(params[:event_id], orchestra, @mail_params[:subject])
          @orchCount += 1
        end
      rescue StandardError
        recordMailFailure(params[:event_id], orchestra, $!)
        @result = { err: $!, entity: orchestra, type: 'O' }
        @results.push(@result)
        @orchFailCount += 1
      end
    end

    if em
      @persons = PersonMember.mailForEvent(@event)
      @persons.each do |person|
        if is_mail_blacklisted?(orchestra.email)
          recordMailFailure(params[:event_id], person, 'blacklist')
          @result = { err: 'blacklisted', entity: person, type: 'P' }
          @results.push(@result)
          @personFailCount += 1
        else
          CustomInfoMail.notify(person.email, params[:email], @att_file, @att_data).deliver
          recordMailSuccess(params[:event_id], person, @mail_params[:subject])
          @personCount += 1
        end
      rescue StandardError
        recordMailFailure(params[:event_id], person, $!)
        @result = { err: $!, entity: person, type: 'P' }
        @results.push(@result)
        @personFailCount += 1
      end
    end

    if festival

      @applicants = if permitted
                      FestivalApplication.includes(:contact_person).where(permission: true)
                    elsif festival_youth
                      FestivalApplication.includes(:contact_person).where(permission: true, group_type: 'Y')
                    elsif festival_soloists
                      FestivalApplication.includes(:contact_person).where(permission: true, group_type: 'S')
                    elsif festival_guests
                      FestivalApplication.includes(:contact_person).where(permission: true, group_type: 'G')
                    else
                      FestivalApplication.includes(:contact_person)
                    end

      @applicants.each do |appl|
        contact = appl.contact_person
        begin
          if is_mail_blacklisted?(contact.email)
            recordMailFailure(params[:event_id], contact, 'blacklist')
            @result = { err: 'blacklisted', entity: contact, type: 'F' }
            @results.push(@result)
            @festivalFailCount += 1
          else
            CustomInfoMail.notify(contact.email, params[:email], @att_file, @att_data).deliver

            recordMailSuccess(params[:event_id], contact, @mail_params[:subject])
            @festivalCount += 1
          end
        rescue StandardError
          recordMailFailure(params[:event_id], contact, $!)
          @result = { err: $!, entity: contact, type: 'F' }
          @results.push(@result)
          @festivalFailCount += 1
        end
      end
    end

    if permitted
      @applicants = FestivalApplication.includes(:contact_person).where(permission: true)
      @applicants.each do |appl|
        contact = appl.contact_person
        begin
          if is_mail_blacklisted?(contact.email)
            recordMailFailure(params[:event_id], contact, 'blacklist')
            @result = { err: 'blacklisted', entity: contact, type: 'F' }
            @results.push(@result)
            @permittedFailCount += 1
          else
            CustomInfoMail.notify(contact.email, params[:email], @att_file, @att_data).deliver

            recordMailSuccess(params[:event_id], contact, @mail_params[:subject])
            @permittedCount += 1
          end
        rescue StandardError
          recordMailFailure(params[:event_id], contact, $!)
          @result = { err: $!, entity: contact, type: 'F' }
          @results.push(@result)
          @permittedFailCount += 1
        end
      end
    end

    respond_to do |format|
      format.html
    end
  end
end
