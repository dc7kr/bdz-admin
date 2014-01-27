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

    datePrefix = Time.now.strftime '%Y%m%d_'
    @mail_params = params[:email]

    letterfile = @mail_params[:datafile]
    attachment = @mail_params[:attachment]

    @grp = @mail_params[:group]

    @via_paper= @mail_params[:via_paper]

    orchestra=false
    em=false
    test=false
    festival=false
  
    if ( @grp == 'A') then
      orchestra = true
      em = true
    elsif ( @grp =='O') then
      orchestra = true
    elsif ( @grp == 'E') then 
      em = true
    elsif ( @grp == 'T') then
      test = true 
    elsif ( @grp == 'F') then
      festival = true
    end

    cur_year = Time.now.year
    date_prefix =  Time.now.strftime("%Y%d%m%H%M_")

    @testCount =0;
    @testFailCount=0;
    @orchCount =0;
    @orchFailCount=0;

    @personCount = 0;
    @personFailCount=0;
    @results =  Array.new

    @att_file=nil
    @att_data=nil

    @event = @mail_params[:event_id]

    if ( letterfile != nil) then
      @letter_file = storeUploadedFile(cur_year.to_s, letterfile.original_filename, letterfile)
    end

    if ( attachment != nil) then
      @attachment = storeUploadedFile(cur_year.to_s, attachment.original_filename, attachment)
    end

    if ( test ) then
      @emails = [ 'thomas.kronenberger@bdz-online.de', 'someone@gibtsnicht.kasi-net.org', 'eckhard.richter@bdz-online.de', 'theresa.brandt@bdz-online.de', 'dominik.hackner@bdz-online.de','karsten.richter@bdz-online.de']
      @emails.each do |email|
        begin
          CustomInfoMail.notify(email,params[:email],@att_file,@att_data).deliver
          @testCount=@testCount+1;
        rescue
          @result = { :err=>$!, :entity=>email,:type=>"T"}
          @results.push(@result)
          @testFailCount=@testFailCount+1;
        end
      end
    end


    letterArray = Array.new 
    if ( orchestra ) then
      @orchestras = Orchestra.mailForEvent(@event,@via_paper)

      @orchestras.each do |orchestra| 
        o_result = deliver_mailing(date_prefix, cur_year.to_s,"gs", orchestra,@mail_params, @letter_file, @attachment, letterArray)
        @results.push(o_result) 
      end
    end

    if ( em ) then
      @persons = PersonMember.mailForEvent(@event, @via_paper) 

      @persons.each do |person| 
        o_result = deliver_mailing(date_prefix, cur_year.to_s,"gs",person,@mail_params,@letter_file, @attachment, letterArray)
        @results.push(o_result) 
      end
    end


    pdf_filename = date_prefix+@mail_params[:event_id]+"_letters.pdf"

    output = File.join(cur_year.to_s,pdf_filename)

    storage_dir = BDZ_SETTINGS["invoice_archive_dir"]
    merge_pdfs(storage_dir, letterArray, output)

    @pdf_link = "#{cron_downloads_url}?year=#{cur_year}&filename=#{pdf_filename}"

    respond_to do |format|
     format.html
    end
  end
end
