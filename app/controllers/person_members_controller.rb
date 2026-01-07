require "rodf"

class PersonMembersController < AuthenticatedController
  helper_method :sort_column, :sort_direction

  before_action :set_person_member, only: %i[ show edit update destroy invoice_preview ]
  include MagazineReportHelper

  # GET /person_members
  # GET /person_members.json
  # TODO: inherited sort!!!
  def index
    @person_members = policy_scope(PersonMember).includes(:member).search(params[:search]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

    respond_to do |format|
      format.js # index.html.erb
      format.html # index.html.erb
      format.json { render json: @person_members }
      format.turbo_stream { render partial: "list", locals: { resources: @person_members } }
      format.ods do
        @person_members = policy_scope(PersonMember).includes(:member).order("#{sort_column} #{sort_direction}")
        renderOds("/tmp/em.ods", @person_members)
        send_file("/tmp/em.ods", filename: "em_#{Time.zone.now.year}.ods", type: "application/octet-stream")
      end
    end
  end

  def invoice_preview
    year = Time.zone.now.year
    @invoice = @person_member.gen_invoice(year)

    @invoice_hash = @invoice.to_hash[:invoice]

    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.json { render json: @invoice }
    end
  end

  def addresses
    @person_members = if params[:nomail]
                        policy_scope(PersonMember).includes(:member).nomail
    else
                        policy_scope(PersonMember).includes(:member).all
    end
    # where("members.email IS NULL or members.email=''")
    respond_to do |format|
      format.json do
        render json: @person_members.to_json(include: { member: {} })
      end
    end
  end

  def notinvoiced
    @person_members = policy_scope(PersonMember).notinvoiced(Time.zone.now.year).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.turbo_stream { render partial: "list", locals: { resources: @person_members } }
      format.json { render json: @person_members }
    end
  end

  def nopayment
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id]) unless params[:regional_organization_id].nil?
    data = policy_scope(PersonMember).no_payment(params[:before], @regional_organization)

    @members = data[:members]
    @accounts = data[:accounts]

    respond_to do |format|
      format.html
      format.json { render json: @members }
      format.csv { render csv: @members, style: :minimal, filename: "nopayment_em_#{Time.zone.now.year}" }
      format.ods do
        renderNoPayOds("/tmp/nopayment.ods", @accounts, @members)
        send_file("/tmp/nopayment.ods", filename: "em_nopay_#{Time.zone.now.year}.ods",
                                        type: "application/octet-stream")
      end
    end
  end

  # GET /person_members/1
  # GET /person_members/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person_member }
    end
  end

  # GET /person_members/new
  # GET /person_members/new.json
  def new
    @person_member = PersonMember.new
    @person_member.build_member
    @person_member.member.country_code = ISO3166::Country["DE"].alpha2
    @person_member.member.magazines = -1

    authorize @person_member

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person_member }
    end
  end

  # GET /person_members/1/edit
  def edit
  end

  # POST /person_members
  # POST /person_members.json
  def create
    @person_member = PersonMember.new(person_member_params)
    authorize @person_member

    respond_to do |format|
      if @person_member.save
        format.html { redirect_to @person_member, notice: "Person member was successfully created." }
        format.json { render json: @person_member, status: :created, location: @person_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /person_members/1
  # PUT /person_members/1.json
  def update

    respond_to do |format|
      if @person_member.update(person_member_params)
        format.html { redirect_to @person_member, notice: "Person member was successfully updated." }
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /person_members/1
  # DELETE /person_members/1.json
  def destroy
    @person_member.destroy

    respond_to do |format|
      format.html { redirect_to person_members_url }
      format.json { head :ok }
    end
  end

  def magazine
    person_members = policy_scope(PersonMember).with_zero_balance
    result = []

    person_members.each do |person_member|
      row = person_member.magazine_address_list_row
      result << row unless row.nil?
    end

    filename = "magazine.em.#{Time.zone.now.strftime('%m-%d-%Y')}.ods"
    render_magazine_address_list("/tmp/#{filename}", result)

    send_file("/tmp/#{filename}", filename: filename, type: "application/octet-stream")

    flash[:notice] = "Export complete!"
  end

  def nomail
    @members = policy_scope(PersonMember).nomail.page(params["page"]).per(20)
    respond_to do |format|
      format.html
    end
  end


  private

  def sort_column
    if Member.column_names.include?(params[:sort])
      "members.#{params[:sort]}"
    else
      PersonMember.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
    end
  end

  def renderNoPayOds(filename, accounts, members)
    RODF::Spreadsheet.file(filename) do
      table "No payment" do
        members.each do |m|
          row do
            cell m.mglnr.to_s
            cell I18n.t("common.salutations.#{m.anrede}")
            cell "#{m.vorname} #{m.name}"
            cell m.strasse
            cell m.plz
            cell m.ort
            cell m.email
            cell accounts[m.id], type: :float
          end
        end
      end
    end
  end

  def renderOds(filename, person_members)
    RODF::Spreadsheet.file(filename) do
      table "EM" do
        person_members.each do |m|
          row do
            cell m.member.mglnr.to_s
            cell I18n.t("common.salutations.#{m.member.anrede}")
            cell "#{m.member.vorname} #{m.member.name}"
            cell m.member.strasse
            cell m.member.plz
            cell m.member.ort
            cell m.member.email
          end
        end
      end
    end
  end

  def person_member_params
    params.require(:person_member).permit(:geburtstag, :telefonDienstl, :tariff_id, :bemerkung, :zeitungen,
                                          :kuendigungVom, :beitrag, :zusatzzeitung, member_attributes: Member.nested_params)
  end

  protected
  def index_actions
    super.append(:notinvoiced, :nopayment, :nomail)
  end

  private
  def set_person_member
    @person_member = policy_scope(PersonMember).includes(:tariff).find(params[:id])
    authorize @person_member
  end
end
