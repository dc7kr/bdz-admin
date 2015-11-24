require "prawn/table"

class ReportSheetInputPdf< Prawn::Document
  include TranslationHelper

  def initialize(rsi, view)
    super(top_margin: 70)
    @rsi= rsi
	  @rs = @rsi.report_sheet
	  @orch = @rsi.orchestra

	  @contacts = Hash.new

	  @orch.orchestra_contacts.each do |c|
		  @contacts[c.role]=c
	  end
    @view = view

     font("Helvetica",:size=>10)
    rsi_head
	  addresses
	  orch_contacts
	  report_sheet
	  #orch_members
	  part4
  end
  
  def rsi_head
    text "Mitgliedermeldung #{@rs.year}, Mgl.Nr: #{@rsi.orchestra.mglnr}", size: 30, style: :bold
  end

  def addresses 
    move_down 20
	text "Anschrift", style: :bold, size: 20
	rows = [
		[t_label('orchestra.orchName'),@orch.orchName ],
		[I18n.t('common.fullname'), I18n.t('common.salutations.'+@orch.anrede)+" "+ @orch.vorname+" "+@orch.name ],
		[t_label('member.street'),	@orch.strasse],
		[t_label('member.city'),	@orch.plz+" "+@orch.ort],
		[t_label('member.phone'), @orch.telefon],
		[t_label('member.fax'), @orch.fax],
		[t_label('member.email'), @orch.email]]

    if @orch.za=='L' then
      rows << [t_label('member.iban'), @orch.iban]
      rows << [t_label('member.bic'), @orch.bic]
      rows << [t_label('member.mref'), @orch.mref]
    end
    
    table rows do
      columns(0).align = :right
	    columns(0).font_style = :bold
      columns(1).align = :left
    end
  end
  
  def orch_contacts
    move_down 20
  	text "Kontaktadressen", style: :bold, size: 10
    table orch_contact_rows do
      row(0).font_style = :bold
      column(0).width=90
      columns(1..3).align = :left
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def orch_contact_rows
    [[t_label('orchestra_contact.role'),I18n.t('common.fullname'), t_label('orchestra_contact.phone'),t_label('orchestra_contact.email') ]] +
	
	OrchestraContact.roles.map do |r| 
		if not @contacts[r].nil? then
	      [I18n.t('orchestra_contact.role_'+r), @contacts[r].first_name+" "+@contacts[r].last_name+", "+@contacts[r].street+", "+@contacts[r].zip+" "+@contacts[r].city, @contacts[r].phone, @contacts[r].email] 
		else
			[]
		end
    end
  end

  def report_sheet 
    move_down 20
	text "1. Beitragspflichtige Mitglieder", style: :bold, size: 20

    table report_sheet_rows do
      column(0).font_style = :bold
      columns(1).align = :right
    end

  end

  def report_sheet_rows
	[
		[t_label('report_sheet.children'),@rsi.report_sheet.children],
		[t_label('report_sheet.teens'),@rsi.report_sheet.teens],
		[t_label('report_sheet.youth'),@rsi.report_sheet.youth],
		[t_label('report_sheet.adult'),@rsi.report_sheet.adult],
		[t_label('report_sheet.senior'),@rsi.report_sheet.senior],
		[t_label('report_sheet.uv'),@rsi.report_sheet.uv ? "Ja" : "Nein"]

	]
  end

  def orch_members
    move_down 20
	text "Mitgliederliste", style: :bold
    table orch_member_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def check_txt(bool)
	if bool then
		"x"
	else
		"-"
	end
  end
  def orch_member_rows
    [[I18n.t('common.fullname'), t_label('orchestra_member.year_of_birth'),t_label('orchestra_member.instrument') ]] +
	
	@orch.orchestra_members.map do |m| 
	    [m.first_name+" "+m.last_name, m.year_of_birth, m.instrument] 
    end
  end


  def part4
    move_down 20

	  text "2. Mitglieder in Ausbildung", style: :bold, size: 20

  	rows = [
	    [t_label('report_sheet.azubi_child'),@rs.azubi_child],
	    [t_label('report_sheet.azubi_teens'), @rs.azubi_teens],
	    [t_label('report_sheet.azubi_youth'),@rs.azubi_youth],
	    [t_label('report_sheet.azubi_adult'),@rs.azubi_adult],
	    [t_label('report_sheet.azubi_senior'), @rs.azubi_senior ]]

    table rows do
      row(0).font_style = :bold
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
	  text "3. Anzahl der passiven Mitglieder (nicht beitragspflichtig)", style: :bold, size: 20

	  rows = [
      [t_label('report_sheet.passive'),@rs.passive ],
			[t_label('report_sheet.supporters'),@rs.supporters]
    ]

    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
	  text "4. Anzahl der Ensembles / Orchester im Verein", style: :bold, size: 20

	  rows = [
		  [t_label('report_sheet.child_ens'),@rs.child_ens],
		  [t_label('report_sheet.youth_ens'),@rs.youth_ens],
		  [t_label('report_sheet.adult_ens'),@rs.adult_ens],
		  [t_label('report_sheet.senior_ens'),@rs.senior_ens],
		  [t_label('report_sheet.other_ens'),@rs.other_ens]
		]

    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
	text "5. Instrumentierung", style: :bold, size: 20
	rows = [
		[t_label('report_sheet.zo'), check_txt(@rs.zo)],
		[t_label('report_sheet.zi_o'),check_txt(@rs.zi_o)],
		[t_label('report_sheet.go'),check_txt(@rs.go)],
		[t_label('report_sheet.oz'),check_txt(@rs.oz)]
		]
    table rows do
      columns(0).align = :right
      columns(1).align = :left
    end
  end

  def price(num)
    @view.number_to_currency(num)
  end
  
  def total_price
    move_down 15
    text "Total Price: #{price(@order.total_price)}", size: 16, style: :bold
  end
end

