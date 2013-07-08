class CustomInfoMailController < AuthenticatedNonResourceController


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
    @festivalFailCount=0
    orchestra = Orchestra.find(420)

    @err = nil
    begin
      TestMail.notify("blah@tiscali.de",@mail_params).deliver
      recordMailSuccess(mail_params[:event_id],orchestra.id, mail_params[:subject])
      @orchCount=@orchCount+1
    rescue
      recordMailFailure(mail_params[:event_id],orchestra.id, orchestra.email, $!.to_s)

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
    @mail_params = params[:email]

    orchestra=false
    em=false
    test=false
    festival=false
  
    @grp = @mail_params[:group]
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

    @testCount =0;
    @testFailCount=0;
    @orchCount =0;
    @orchFailCount=0;
    @personCount = 0;
    @personFailCount=0;
    @results =  Array.new

    datafile = @mail_params[:datafile]
    @att_file=nil
    @att_data=nil

    @event = @mail_params[:event_id]

    if ( datafile != nil) then
      @att_file = datafile.original_filename
      @att_data = readDataFile(@mail_params)
    end

    if ( test ) then
      @emails = [ 'thomas.kronenberger@bdz-online.de', 'someone@gibtsnicht.kasi-net.org', 'eckhard.richter@bdz-online.de', 'theresa.brandt@bdz-online.de', 'dominik.hackner@bdz-online.de','karsten.richter@bdz-online.de']
      #@emails = [ 'karsten.richter@gmail.com', 'someone@gibtsnicht.kasi-net.org', 'karsten.richter@bdz-online.de']
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

    if ( orchestra ) then
      @orchestras = Orchestra.mailForEvent(@event)

      @orchestras.each do |orchestra| 
        begin 
          if not is_mail_blacklisted(orchestra.email) then
            CustomInfoMail.notify(orchestra.email,params[:email],@att_file,@att_data).deliver
            recordMailSuccess(@mail_params,orchestra.id)
            @orchCount=@orchCount+1
          else 
            recordMailFailure(params[:event_id],params[:email],orchestra.id,"blacklisted")

            @result = { :err=>"blacklisted", :entity=>orchestra,:type =>"O"}
            @results.push(@result)
            @orchFailCount=@orchFailCount+1;
          end
        rescue
          recordMailFailure(params[:event_id],params[:email],orchestra.id,$!)
          @result = { :err=>$!, :entity=>orchestra,:type =>"O"}
          @results.push(@result)
          @orchFailCount=@orchFailCount+1;
        end
      end
    end

    if ( em ) then
      @persons = PersonMember.mailForEvent(@event) 
      @persons.each do |person| 
        begin 
          if not is_mail_blacklisted(orchestra.email) then
            CustomInfoMail.notify(person.email,params[:email],@att_file,@att_data).deliver
            recordMailSuccess(@mail_params,person.id)
            @personCount=@personCount+1
          else 
            recordMailFailure(params[:event_id],@mail_params,person.id,"blacklist")
            @result = { :err=>"blacklisted", :entity=>person,:type =>"P"}
            @results.push(@result)
            @personFailCount+=1;
          end
        rescue
          recordMailFailure($!,@mail_params,person.id)
          @result = { :err=>$!, :entity=>person,:type =>"P"}
          @results.push(@result)
          @personFailCount+=1;
        end
      end
    end

    if ( festival ) then
      @applicants = FestivalApplications.includes(:contact_person)
      @applicants.each do |appl|
        contact = appl.contact_person
        begin 
          if not is_mail_blacklisted(contact.email) then
            CustomInfoMail.notify(contact.email,params[:email],@att_file,@att_data).deliver
            recordMailSuccess(@mail_params,contact.id)
            @personCount=@personCount+1
          else 
            recordMailFailure(params[:event_id],@mail_params,contact.id,"blacklist")
            @result = { :err=>"blacklisted", :entity=>appl,:type =>"F"}
            @results.push(@result)
            @festivalFailCount+=1;
          end
        rescue
          recordMailFailure($!,@mail_params,contact.id)
          @result = { :err=>$!, :entity=>contact,:type =>"F"}
          @results.push(@result)
          @festivalFailCount+=1;
        end
      end
    end

    respond_to do |format|
     format.html
  end
  end
end
