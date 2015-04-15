require 'odf/spreadsheet'

class PersonMembersController < AuthenticatedController
#  before_filter :authenticate_user!, :except => @publicActions
#[:some_action_without_auth]
  helper_method :sort_column, :sort_direction

  # GET /person_members
  # GET /person_members.json
# TODO: inherited sort!!!
  def index
    @person_members = @person_members.includes(:member).search(params[:search]).order(sort_column+" "+sort_direction).page(params[:page]).per(20)


    respond_to do |format|
      format.js # index.html.erb
      format.html # index.html.erb
      format.json { render :json => @person_members }
    end
  end

  def addresses 
    if (params[:nomail]) then
		@person_members = PersonMember.includes(:member).nomail
	else
		@person_members = PersonMember.includes(:member).all
	end
#where("members.email IS NULL or members.email=''")
	respond_to do |format|
		format.json { render :json => @person_members.to_json(:include => {:member=> {} })
		}
	end
  end

  def notinvoiced 
    @person_members = PersonMember.includes([:tariff,:member]).joins("LEFT JOIN member_account_bookings mb ON person_members.member_id=mb.member_id AND mb.booking_type='B' and mb.booking_year = YEAR(NOW())").where("mb.id IS NULL").order("members.mglnr").page(params[:page]).per(20)
	
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @person_members }
    end

  end

  def nopayment
	@accounts = MemberAccountBooking.sum(:amount,:group=>:member_id)

	@ids = Set.new
	@accounts.each do |account|
      if (account[1]<0) then
        @ids.add(account[0])
	  end
	end
	@person_members= PersonMember.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])

    respond_to do |format|
     format.html
     format.json { render :json => @person_members }
	 format.csv { render :csv => @person_members, :style=>:minimal, :filename => "nopayment_em_"+Time.now.year.to_s }
	 format.ods {
			renderNoPayOds("/tmp/nopayment.ods",@accounts,@person_members);
    		send_file("/tmp/nopayment.ods", :filename => "em_nopay_"+Time.now.year.to_s+".ods", :type => "application/octet-stream")
		}
    end
  end
  # GET /person_members/1
  # GET /person_members/1.json
  def show
    @person_member = PersonMember.includes(:tariff).find(params[:id])
    #@bookings = @person_member.member_account_bookings

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @person_member }
    end
  end

  # GET /person_members/new
  # GET /person_members/new.json
  def new
    @person_member = PersonMember.new
    @person_member.zeitungen=1
    @person_member.country_code = "de"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @person_member }
    end
  end

  # GET /person_members/1/edit
  def edit
    @person_member = PersonMember.find(params[:id])
  end

  # POST /person_members
  # POST /person_members.json
  def create
    @person_member = PersonMember.new(params[:person_member])

    respond_to do |format|
      if @person_member.save
        format.html { redirect_to @person_member, :notice => 'Person member was successfully created.' }
        format.json { render :json => @person_member, :status => :created, :location => @person_member }
      else
        format.html { render :action => "new" }
        format.json { render :json => @person_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_members/1
  # PUT /person_members/1.json
  def update
    @person_member = PersonMember.find(params[:id])

    respond_to do |format|
      if @person_member.update_attributes(params[:person_member])
        format.html { redirect_to @person_member, :notice => 'Person member was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @person_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_members/1
  # DELETE /person_members/1.json
  def destroy
    @person_member = PersonMember.find(params[:id])
    @person_member.destroy

    respond_to do |format|
      format.html { redirect_to person_members_url }
      format.json { head :ok }
    end
  end

  def magazine 

  @person_members = PersonMember.with_zero_balance

	@result = Array.new

	@person_members.each do |person_member|
		if ( person_member.currentMagazines >0) then
		  @csvrow = {
			:mglnr=>person_member.mglnr,
			:name=> '',
			:name2=>'',
			:vorname=>person_member.vorname,
			:nachname=>person_member.name,
			:strasse=>person_member.strasse ,
			:countryCode=>person_member.countryCode,
			:plz=>person_member.plz,
			:ort=>person_member.ort,
			:land=>person_member.letterCountry,
			:magazines=>person_member.currentMagazines

		  }
		  @result << @csvrow
		end
	end
  	@outfile = "concertino.em." + Time.now.strftime("%m-%d-%Y") + ".csv"
 
  csv_data = CSV.generate do |csv|
    csv << [
    "Lfd Nr",
    "Mglnr",
    "Firma",
    "Firma2",
    "Vorname",
    "Name",
    "Strasse",
	"Laendercode",
    "PLZ",
    "Ort",
    "Land",
    "Zeitungen"
    ]
	@nr=1
    @result.sort_by { |item| item[:magazines]}.each do |data|
		csv << [
			@nr,
            data[:mglnr],
            data[:name],
            data[:name2],
            data[:vorname],
            data[:nachname],
            data[:strasse],
			data[:countryCode],
            data[:plz],
            data[:ort],
            data[:land],
            data[:magazines]
		]
		@nr=@nr+1
    end
	end
 	send_data csv_data,
    	:type => 'text/csv; charset=iso-8859-1; header=present',
    	:disposition => "attachment; filename=#{@outfile}"

  	flash[:notice] = "Export complete!"
  end


  private 
  def sort_column
    Member.column_names.include?(params[:sort]) ? "members."+params[:sort] :
    PersonMember.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
  end

  private
  def renderNoPayOds(filename,accounts,person_members)
	ODF::Spreadsheet.file(filename) do
				table "No payment"  do
	    			person_members.each do |pm|
						row {
							cell pm.mglnr.to_s
							cell pm.vorname+" "+pm.name
							cell pm.email
							cell accounts[pm.member_id],:type=>:float
						}
					end
  				end
			end
  end
end
