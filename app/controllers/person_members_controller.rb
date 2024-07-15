require 'rodf'

class PersonMembersController < AuthenticatedController
#  before_action :authenticate_user!, :except => @publicActions
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
      format.ods {
        @person_members = PersonMember.includes(:member).order(sort_column+" "+sort_direction)
        renderOds("/tmp/em.ods", @person_members);
          send_file("/tmp/em.ods", :filename => "em_"+Time.now.year.to_s+".ods", :type => "application/octet-stream")
      }
    end
  end

  def invoice_preview
    year = Time.now.year
    @invoice = @person_member.gen_invoice(year)
    
    respond_to do |format|
      format.turbo_stream
      format.html
      format.json { render :json => @invoice }
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
    @person_members = @person_members.notinvoiced(Time.now.year).page(params[:page]).per(20)

	
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @person_members }
    end

  end

  def nopayment
    if not params[:regional_organization_id].nil?
      @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    end
    data = @person_members.no_payment(params[:before], @regional_organization)

    @members = data[:members]
    @accounts = data[:accounts]

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
    @person_member.member.country_code = ISO3166::Country['DE'].alpha2
    @person_member.member.magazines=-1

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
        format.html { render :new, status: :unprocessable_entity }
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
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render :json => @person_member.errors,  status: :unprocessable_entity } 
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
    person_members = PersonMember.with_zero_balance
    result = Array.new

    person_members.each do |person_member|
      row = person_member.magazine_address_list_row
      if not row.nil?
        result << row
      end
    end
    
    filename = "magazine.em." + Time.now.strftime("%m-%d-%Y") + ".ods"
    render_magazine_address_list("/tmp/"+filename,result)

    send_file("/tmp/"+filename, :filename => filename, :type => "application/octet-stream")

    flash[:notice] = "Export complete!"
 
  end


  def nomail 
    @members = PersonMember.nomail
    	respond_to do |format|
      format.html
    end
  end
	


  private 
  def sort_column
    Member.column_names.include?(params[:sort]) ? "members."+params[:sort] :
    PersonMember.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
  end

  private
  def renderNoPayOds(filename,accounts,members)
	RODF::Spreadsheet.file(filename) do
				table "No payment"  do
	    			members.each do |m|
						row {
							cell m.mglnr.to_s
							cell I18n.t("common.salutations.#{m.anrede}")
							cell m.vorname+" "+m.name
							cell m.strasse
							cell m.plz
							cell m.ort
							cell m.email
							cell accounts[m.id],:type=>:float
						}
					end
  				end
			end
  end

  def renderOds(filename,person_members)
    RODF::Spreadsheet.file(filename) do
			table "EM"  do
	   		person_members.each do |m|
          row {
            cell m.member.mglnr.to_s
            cell I18n.t("common.salutations.#{m.member.anrede}")
            cell m.member.vorname+" "+m.member.name
            cell m.member.strasse
            cell m.member.plz
            cell m.member.ort
            cell m.member.email
          }
			  end
  		end
		end
  end

  def person_member_params()
    params.require(:person_member).permit(:geburtstag, :telefonDienstl, :tariff_id, :bemerkung, :zeitungen, :kuendigungVom, :beitrag, :zusatzzeitung,member_attributes: Member.nested_params) 
  end
end
