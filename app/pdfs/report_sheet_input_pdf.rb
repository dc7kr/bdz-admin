class ReportSheetInputPdf< Prawn::Document
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
    rsi_head
	addresses
	orch_contacts
	orch_members
	part4
  end
  
  def rsi_head
    text "Mitgliedermeldung #{@rs.year}, Mgl.Nr: #{@rsi.orchestra.mglnr}", size: 30, style: :bold
  end

  def addresses 
    move_down 20
	text "Anschrift", style: :bold, size: 20
	rows = [
		[@view.t('orchestra.orchName'),@orch.orchName ],
		[@view.t('common.fullname'), @view.t('common.salutation.'+@orch.anrede)+" "+ @orch.vorname+" "+@orch.name ],
		[@view.t('member.street'),	@orch.strasse],
		[@view.t('member.city'),	@orch.plz+" "+@orch.ort],
		[@view.t('member.phone'), @orch.telefon],
		[@view.t('member.fax'), @orch.fax],
		[@view.t('member.email'), @orch.email]]
    table rows do
      columns(0).align = :right
	  columns(0).font_style = :bold
      columns(1).align = :left
    end
  end
  
  def orch_contacts
    move_down 20
	text "Kontaktadressen", style: :bold
    table orch_contact_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def orch_contact_rows
    [[@view.t('orchestra_contact.role'),@view.t('common.fullname'), @view.t('orchestra_contact.street'),@view.t('orchestra_contact.city'),@view.t('orchestra_contact.phone'),@view.t('orchestra_contact.email') ]] +
	
	OrchestraContact.roles.map do |r| 
		if (@contacts[r]!=nil) then
	      [@view.t('orchestra_contact.role_'+r), @contacts[r].first_name+" "+@contacts[r].last_name, @contacts[r].street,@contacts[r].zip+" "+@contacts[r].city, @contacts[r].phone, @contacts[r].email] 
		else
			[]
		end
    end
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
    [[@view.t('common.fullname'), @view.t('orchestra_member.date_of_birth'),@view.t('orchestra_member.instrument') ]] +
	
	@orch.orchestra_members.map do |m| 
	    [m.first_name+" "+m.last_name, @view.l(m.date_of_birth), m.instrument] 
    end
  end


  def part4
    move_down 20

	text "1.Mitglieder in Ausbildung", style: :bold, size: 20

	rows = [
	[@view.t('report_sheet.azubi_child'),@rs.azubi_child],
	[@view.t('report_sheet.azubi_teens'), @rs.azubi_teens],
	[@view.t('report_sheet.azubi_youth'),@rs.azubi_youth],
	[@view.t('report_sheet.azubi_adult'),@rs.azubi_adult],
	[@view.t('report_sheet.azubi_senior'), @rs.azubi_senior ]]

    table rows do
      row(0).font_style = :bold
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
	text "2. Anzahl der passiven Mitglieder (nicht beitragspflichtig)", style: :bold, size: 20

	rows = [[@view.t('report_sheet.passive'),@rs.passive ],
			[@view.t('report_sheet.supporters'),@rs.supporters]]


    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
	text "3. Anzahl der Ensembles / Orchester im Verein", style: :bold, size: 20

	rows = [
		[@view.t('report_sheet.child_ens'),@rs.child_ens],
		[@view.t('report_sheet.youth_ens'),@rs.youth_ens],
		[@view.t('report_sheet.adult_ens'),@rs.adult_ens],
		[@view.t('report_sheet.senior_ens'),@rs.senior_ens],
		[@view.t('report_sheet.other_ens'),@rs.other_ens]
		]

    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
	text "4. Instrumentierung", style: :bold, size: 20
	rows = [
		[@view.t('report_sheet.zo'), check_txt(@rs.zo)],
		[@view.t('report_sheet.zi_o'),check_txt(@rs.zi_o)],
		[@view.t('report_sheet.go'),check_txt(@rs.go)],
		[@view.t('report_sheet.oz'),check_txt(@rs.oz)]
		]
    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
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

