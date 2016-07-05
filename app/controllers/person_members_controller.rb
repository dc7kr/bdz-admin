require 'odf/spreadsheet'

class PersonMembersController < AuthenticatedController
#  before_filter :authenticate_user!, :except => @publicActions
#[:some_action_without_auth]
  helper_method :sort_column, :sort_direction
  include MagazineReportHelper

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
    @person_members = PersonMember.notinvoiced(Time.now.year).page(params[:page]).per(20)

	
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @person_members }
    end

  end

  def nopayment
    data = MemberAccountBooking.unbalanced_before(params[:before])

    @ids = data[:ids]
    @accounts = data[:accounts]

    @members = Member.includes(:member_entity).where("member_entity_type='PersonMember' and id in (?)",@ids.to_a).order(:mglnr)

    respond_to do |format|
     format.html
     format.json { render :json => @members }
     format.csv { render :csv => @members, :style=>:minimal, :filename => "nopayment_em_"+Time.now.year.to_s }
     format.ods {
        renderNoPayOds("/tmp/nopayment.ods",@accounts,@members);
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
    @person_member.build_member
    @person_member.zeitungen=1
    @person_member.member.country_code = ISO3166::Country['DE'].alpha2

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
    @person_member = PersonMember.new(person_member_params)

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
      if @person_member.update(person_member_params)
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
        member = person_member.member
        @csvrow = {
          :mglnr=>member.mglnr,
          :name=> '',
          :name2=>'',
          :vorname=>member.vorname,
          :nachname=>member.name,
          :strasse=>member.strasse ,
          :countryCode=>member.countryCode,
          :plz=>member.plz,
          :ort=>member.ort,
          :land=>member.letterCountry,
          :magazines=>1
        }
        @result << @csvrow
      end
    end
    
    filename = "magazine.em." + Time.now.strftime("%m-%d-%Y") + ".ods"
    renderPersonMembersMagazineListOds("/tmp/"+filename,@result)

    send_file("/tmp/"+filename, :filename => filename, :type => "application/octet-stream")

    flash[:notice] = "Export complete!"
 
  end


  private 
  def sort_column
    Member.column_names.include?(params[:sort]) ? "members."+params[:sort] :
    PersonMember.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
  end

  private
  def renderNoPayOds(filename,accounts,members)
	ODF::Spreadsheet.file(filename) do
				table "No payment"  do
	    			members.each do |m|
						row {
							cell m.mglnr.to_s
							cell m.vorname+" "+m.name
							cell m.email
							cell accounts[m.id],:type=>:float
						}
					end
  				end
			end
  end

  def person_member_params()
    params.require(:person_member).permit(:geburtstag, :telefonDienstl, :tariff_id, :bemerkung, :zeitungen, :kuendigungVom, :beitrag, :zusatzzeitung,member_attributes: Member.nested_params) 
  end
end
