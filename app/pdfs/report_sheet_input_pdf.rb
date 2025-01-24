class ReportSheetInputPdf < Prawn::Document
  include TranslationHelper

  def initialize(entity, view)
    super(top_margin: 70)

    if entity.is_a? ReportSheet 
      @rs = entity
      @orchestra = @rs.orchestra
    else 
      @rs = entity.report_sheet
      @orchestra = entity.orchestra
    end

    @contacts = {}

    @orchestra.orchestra_contacts.each do |c|
      @contacts[c.role] = c
    end
    @view = view

    font('Helvetica', size: 10)
    rsi_head
    addresses
    orch_contacts
    report_sheet
    #	  #orch_members
    part4
  end

  def rsi_head
    text "Mitgliedermeldung #{@rs.year}, Mgl.Nr: #{@orchestra.member.mglnr}", size: 30, style: :bold
  end

  def addresses
    move_down 20
    text 'Anschrift', style: :bold, size: 20
    member = @orchestra.member
    rows = [
      [t_label('orchestra.orchName'), @orchestra.orchName],
      [I18n.t('common.fullname'),
       I18n.t('common.salutations.' + member.anrede) + ' ' + member.vorname + ' ' + member.name],
      [t_label('member.street'),	member.strasse],
      [t_label('member.city'),	member.plz + ' ' + member.ort],
      [t_label('member.phone'), member.telefon],
      [t_label('member.fax'), member.fax],
      [t_label('member.email'), member.email]
    ]

    if member.za == 'L'
      rows << [t_label('member.iban'), member.iban]
      rows << [t_label('member.bic'), member.bic]
      rows << [t_label('member.mref'), member.mref]
    end

    table rows do
      columns(0).align = :right
      columns(0).font_style = :bold
      columns(1).align = :left
    end
  end

  def orch_contacts
    move_down 20
    text 'Kontaktadressen', style: :bold, size: 10
    table orch_contact_rows do
      row(0).font_style = :bold
      column(0).width = 90
      columns(1..3).align = :left
      self.row_colors = %w[DDDDDD FFFFFF]
      self.header = true
    end
  end

  def orch_contact_rows
    contact_rows =
      [[t_label('orchestra_contact.role'), I18n.t('common.fullname'), t_label('orchestra_contact.phone'),
        t_label('orchestra_contact.email')]]

    OrchestraContact.roles.map do |r|
      unless @contacts[r].nil?
        contact_rows << [I18n.t('orchestra_contact.role_' + r),
                         @contacts[r].first_name + ' ' + @contacts[r].last_name + ', ' + @contacts[r].street + ', ' + @contacts[r].zip + ' ' + @contacts[r].city, @contacts[r].phone, @contacts[r].email]
      end
    end

    contact_rows
  end

  def report_sheet
    move_down 20
    text '1. Beitragspflichtige Mitglieder', style: :bold, size: 20

    table report_sheet_rows do
      column(0).font_style = :bold
      columns(1).align = :right
    end
  end

  def report_sheet_rows
    [
      [t_label('report_sheet.children'), @rs.children],
      [t_label('report_sheet.teens'), @rs.teens],
      [t_label('report_sheet.youth'), @rs.youth],
      [t_label('report_sheet.adult'), @rs.adult],
      [t_label('report_sheet.senior'), @rs.senior],
      [t_label('report_sheet.uv'), @rs.uv ? 'Ja' : 'Nein']

    ]
  end

  def orch_members
    move_down 20
    text 'Mitgliederliste', style: :bold
    table orch_member_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = %w[DDDDDD FFFFFF]
      self.header = true
    end
  end

  def check_txt(bool)
    if bool
      'x'
    else
      '-'
    end
  end

  def orch_member_rows
    [[I18n.t('common.fullname'), t_label('orchestra_member.year_of_birth'), t_label('orchestra_member.instrument')]] +
      @orchestra.orchestra_members.map do |m|
        [m.first_name + ' ' + m.last_name, m.year_of_birth, m.instrument]
      end
  end

  def part4
    move_down 20

    text '2. Mitglieder in Ausbildung', style: :bold, size: 20

    rows = [
      [t_label('report_sheet.azubi_child'), @rs.azubi_child],
      [t_label('report_sheet.azubi_teens'), @rs.azubi_teens],
      [t_label('report_sheet.azubi_youth'), @rs.azubi_youth],
      [t_label('report_sheet.azubi_adult'), @rs.azubi_adult],
      [t_label('report_sheet.azubi_senior'), @rs.azubi_senior]
    ]

    table rows do
      row(0).font_style = :bold
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
    text '3. Anzahl der passiven Mitglieder (nicht beitragspflichtig)', style: :bold, size: 20

    rows = [
      [t_label('report_sheet.passive'), @rs.passive],
      [t_label('report_sheet.supporters'), @rs.supporters]
    ]

    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
    text '4. Anzahl der Ensembles / Orchester im Verein', style: :bold, size: 20

    rows = [
      [t_label('report_sheet.child_ens'), @rs.child_ens],
      [t_label('report_sheet.youth_ens'), @rs.youth_ens],
      [t_label('report_sheet.adult_ens'), @rs.adult_ens],
      [t_label('report_sheet.senior_ens'), @rs.senior_ens],
      [t_label('report_sheet.other_ens'), @rs.other_ens]
    ]

    table rows do
      columns(0).align = :right
      columns(1).align = :left
      self.header = true
    end

    move_down 20
    text '5. Instrumentierung', style: :bold, size: 20
    rows = [
      [t_label('report_sheet.zo'), check_txt(@rs.zo)],
      [t_label('report_sheet.zi_o'), check_txt(@rs.zi_o)],
      [t_label('report_sheet.go'), check_txt(@rs.go)],
      [t_label('report_sheet.oz'), check_txt(@rs.oz)]
    ]
    table rows do
      columns(0).align = :right
      columns(1).align = :left
    end

    if not @rs.ms_total.nil? and @rs.ms_total > 0 
      move_down 20
      text '6. Musikschulen', style: :bold, size: 20
      rows = [
        [t_label('report_sheet.ms_total'), @rs.ms_total]
      ]
      table rows do
        columns(0).align = :right
        columns(1).align = :left
      end
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
