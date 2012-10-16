class CustomInfoMailController < AuthenticatedNonResourceController

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
			recordMailSuccess(@mail_params,420)
			@orchCount=@orchCount+1
		rescue
			recordMailFailure($!,@mail_params,orchestra.id)
			@result = { :err=>$!, :entity=>orchestra,:type =>"O"}
			@results.push(@result)
			@orchFailCount=@orchFailCount+1;
		end

		respond_to do |format|
			format.html
		end
  end

  def readDataFile(email_params)
	if ( email_params[:datafile] ) then 
		dataFile = email_params[:datafile]
		return dataFile.read
	else
		return nil
	end
  end

  def recordMailSuccess(mail_params,id)
	event = MemberEvent.newEmail(mail_params[:event_id],id,mail_params[:subject])
	event.save
  end

  def recordMailFailure(result,mail_params,id)
		event = MemberEvent.newFailedEmail(@mail_params[:event_id],id,result.to_s)
		event.save
  end
		
  def send_mail
	authorize! :member, :edit
	@mail_params = params[:email]

	orchestra=false
	em=false
	test=false
	
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
					CustomInfoMail.notify(orchestra.email,params[:email],@att_file,@att_data).deliver
					recordMailSuccess(@mail_params,orchestra.id)
					@orchCount=@orchCount+1
				rescue
					recordMailFailure($!,params[:email],orchestra.id)
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
				CustomInfoMail.notify(person.email,params[:email],@att_file,@att_data).deliver
				recordMailSuccess(@mail_params,person.id)
				@personCount=@personCount+1
			rescue
				recordMailFailure($!,@mail_params,person.id)
				@result = { :err=>$!, :entity=>person,:type =>"P"}
				@results.push(@result)
				@personFailCount=@personFailCount+1;
			end
		end
	end

    respond_to do |format|
     format.html
	end
  end
end
