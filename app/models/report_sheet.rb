require 'rodf'
class ReportSheet < ApplicationRecord
  validates :report_date, presence: { unless: -> { orchestra.blank? } }
  validates :adult, presence: true
  validates :adult_ens, presence: true
  validates :azubi, presence: true
  validates :chamber_ens, presence: true
  validates :child_ens, presence: true
  validates :children, presence: true
  validates :passive, presence: true
  validates :senior, presence: true
  validates :senior_ens, presence: true
  validates :teens, presence: true
  validates :uv, inclusion: { in: [true, false] }
  validates :youth, presence: true
  validates :youth_ens, presence: true
  validates :zusatz_uv, presence: true
  validates :zusatz_ztg, presence: true

  validate :at_least_one_member

  belongs_to :orchestra, optional: true
  has_one :member, through: :orchestra

  has_one :regional_organization, through: :member

  def self.for_regional_organization(year, regional_organization_id)
    lv = RegionalOrganization.find(regional_organization_id)
    ids = lv.orchestras.pluck(:id)

    ReportSheet.includes(:orchestra).where('orchestra_id in (?) and year=?', ids, year)
  end

  scope :final, ->(year) { where('year = ? and orchestra_id is not null', year) }
  scope :not_final, -> {  where(orchestra_id: nil) }

  scope :current,
        -> { { conditions: ['year =  ?', String(Time.zone.now.year)] } }

  def self.age_categories
    @@age_categories = %w[C T Y A S]
  end

  def init_empty
    self.adult ||= 0
    self.adult_ens ||= 0
    self.azubi ||= 0
    self.chamber_ens ||= 0
    self.child_ens ||= 0
    self.children ||= 0
    self.korr_ztg ||= 0
    self.other_ens ||= 0
    self.passive ||= 0
    self.senior ||= 0
    self.senior_ens ||= 0
    self.teens ||= 0
    self.token ||= 0

    if uv.nil?
      self.uv = false
    else
      logger.debug 'UV was not nil'
    end

    self.youth ||= 0
    self.youth_ens ||= 0
    self.zusatz_uv ||= 0
    self.zusatz_ztg ||= 0
  end

  def self.new_for_year(year)
    report_sheet = ReportSheet.new
    report_sheet.init_empty
    report_sheet.orchestra = nil
    report_sheet.year = year

    report_sheet
  end

  def self.for_orchestra_and_year(orchestra, year)
    report_sheet = ReportSheet.where('orchestra_id = ? and year = ?', orchestra.id, year).first

    if report_sheet.nil?
      report_sheet = ReportSheet.new
      report_sheet.init_empty
      report_sheet.orchestra = orchestra
      report_sheet.year = year
    end

    report_sheet
  end

  def report_date_str=(newval)
    self.report_date = Date.parse(newval)
  end

  def report_date_str
    if report_date
      I18n.l(report_date)
    else
      ''
    end
  end

  def calcRawTariff
    (children * Prices.childrenRate) +
      (youth * Prices.youthRate) +
      (teens * Prices.teensRate) +
      (adult * Prices.adultRate) +
      (senior * Prices.seniorRate)
  end

  def calcBeitrag
    if orchestra.is_coop?
      return Prices.coopRate
    elsif orchestra.is_foreign_coop?
      return Prices.foreignCoopRate
    elsif orchestra.is_lorch?
      return Prices.lvOrchRate + (calcGemaCount * Prices.lvMember)
    end

    val = calcRawTariff

    return Prices.minTariff if val < Prices.minTariff
    return Prices.maxTariff if val > Prices.maxTariff

    val
  end

  def isMinTariff?
    calcRawTariff < Prices.minTariff
  end

  def isMaxTariff?
    calcRawTariff > Prices.maxTariff
  end

  def totalActiveMembers
    # TODO: need a clean solution for the double members
    if orchestra.is_lorch?
      youth + teens + adult + senior
    else
      youth + teens + adult + senior + azubi
    end
  end

  def calcGemaCount
    # TODO: need a clean solution for the double members
    if !orchestra.nil? && orchestra.is_lorch?
      youth + teens + adult + senior - azubi
    else
      youth + teens + adult + senior
    end
  end

  def calcUvCount
    if uv && !orchestra.is_coop?
      children + teens + youth + adult + senior + zusatz_uv
    else
      0
    end
  end

  def calcUV
    calcUvCount * Prices.uvRate
  end

  def calcInvoice
    sum = calcUV + calcBeitrag

    sum += Prices.delayFee if delayed?
    sum
  end

  def calcLvPart
    calcBeitrag * BDZ_SETTINGS['tariff']['lvPart']
  end

  def kronenberger_algorithm
    case calcGemaCount
    when 0
      0
    when 1..8
      1
    when 9..16
      2
    when 17..28
      4
    when 29..40
      5
    when 41..99
      10
    else
      20
    end
  end

  def calcZeitungen
    return Prices.loZtgCount if orchestra.is_lorch?

    kronenberger_algorithm
    #		@ztg = (calcGemaCount*Prices.ztgRate).ceil
    #		if ( korr_ztg != nil ) then
    #			@ztg += korr_ztg;
    #		end
    #  return @ztg
  end

  # gema report sheet CSV
  comma :gema do
    calcGemaCount
  end

  def ageKeyStr
    str = '|'
    str += "#{children}|"
    str += "#{teens}|"
    str += "#{youth}|"
    str += "#{adult}|"
    str += "#{senior}|"

    str
  end

  def delayed?
    if report_date.nil?
      false
    else
      report_date >= Date.new(year, 3, 1)
    end
  end

  def gen_invoice_pdf(_tex_writer, invoice, generator_session_id = nil)
    generator_session_id = SecureRandom.uuid if generator_session_id.nil?

    invoice.generator_session_id = generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf(tex_writer)
    String(year)

    invoice_file
  end

  def add_invoice_items(invoice)
    if orchestra.is_coop? || orchestra.is_foreign_coop?
      logger.info('No additional items - special orchestra')
      return
    elsif orchestra.is_lorch?
      # regional orchestras only pay a fixed fee no calculation...
      invoice.addItem(1, Prices.lvOrchRate, 'Landesorchesterbeitrag')
    else
      if isMinTariff? || isMaxTariff?
        # in case of min or max tariff we don't
        # charge the real fees but 0 (just print out the statistics)
        invoice.addItem(children, 0, I18n.t('report_sheet.children_rate'))
        invoice.addItem(teens, 0, I18n.t('report_sheet.teens_rate'))
        invoice.addItem(youth, 0, I18n.t('report_sheet.youth_rate'))
        invoice.addItem(adult, 0, I18n.t('report_sheet.adult_rate'))
        invoice.addItem(senior, 0, I18n.t('report_sheet.senior_rate'))
      else
        # regular price calculation
        invoice.addItem(children, Prices.childrenRate, I18n.t('report_sheet.children_rate'))
        invoice.addItem(teens, Prices.teensRate, I18n.t('report_sheet.teens_rate'))
        invoice.addItem(youth, Prices.youthRate, I18n.t('report_sheet.youth_rate'))
        invoice.addItem(adult, Prices.adultRate, I18n.t('report_sheet.adult_rate'))
        invoice.addItem(senior, Prices.seniorRate, I18n.t('report_sheet.senior_rate'))
      end

      if isMinTariff?
        invoice.addItem(1, Prices.minTariff, I18n.t('report_sheet.min_tariff'))
      elsif isMaxTariff?
        invoice.addItem(1, Prices.maxTariff, I18n.t('report_sheet.max_tariff'))
      end
    end

    invoice.addItem(calcUvCount, Prices.uvRate, I18n.t('report_sheet.uv')) if uv

    invoice.addItem(1, Prices.delayFee, I18n.t('report_sheet.delay_fee')) if delayed?

    invoice
  end

  def gen_delta_booking(sepa_writer, invoice, delta_value)
    if delta_value.negative?
      booking_txt = "Beitragserstattung #{String(year)}"
      booking = orchestra.member.create_credit_transfer(sepa_writer, year, booking_txt, -1 * delta_value)
    else
      String(year)
      booking = orchestra.member.create_dd_booking(sepa_writer, invoice, year, delta_value)
    end
    booking
  end

  def total_ensembles
    data = [child_ens, youth_ens, adult_ens, senior_ens, chamber_ens]

    sum = data.compact.sum

    sum = 1 if sum == 0

    sum
  end

  def ens_key_string
    data = [child_ens, youth_ens, adult_ens, senior_ens, chamber_ens]
    data.map!(&:to_i)
    "|#{data.join('|')}|"
  end

  def update_stats(hash, key, value)
    hash[key] += value unless value.nil?
  end

  def self.renderOds(report_sheets, filename)
    RODF::Spreadsheet.file(filename) do
      table 'Meldebögen' do
        row do
          cell I18n.t('member.mglnr')
          cell I18n.t('common.year')
          cell I18n.t('helpers.label.report_sheet.children')
          cell I18n.t('helpers.label.report_sheet.teens')
          cell I18n.t('helpers.label.report_sheet.youth')
          cell I18n.t('helpers.label.report_sheet.adult')
          cell I18n.t('helpers.label.report_sheet.senior')
          cell I18n.t('helpers.label.report_sheet.uv')
          cell I18n.t('helpers.label.report_sheet.zusatz_uv')
          cell I18n.t('helpers.label.report_sheet.gema')
          cell I18n.t('helpers.label.report_sheet.azubi')
          cell I18n.t('helpers.label.report_sheet.passive')
          cell I18n.t('helpers.label.report_sheet.child_ens')
          cell I18n.t('helpers.label.report_sheet.youth_ens')
          cell I18n.t('helpers.label.report_sheet.adult_ens')
          cell I18n.t('helpers.label.report_sheet.senior_ens')
          cell I18n.t('helpers.label.report_sheet.chamber_ens')
          cell I18n.t('helpers.label.report_sheet.other_ens')
          cell I18n.t('helpers.label.report_sheet.azubi_child')
          cell I18n.t('helpers.label.report_sheet.azubi_teens')
          cell I18n.t('helpers.label.report_sheet.azubi_youth')
          cell I18n.t('helpers.label.report_sheet.azubi_adult')
          cell I18n.t('helpers.label.report_sheet.azubi_senior')
          cell I18n.t('helpers.label.report_sheet.supporters')
          cell I18n.t('helpers.label.report_sheet.zo')
          cell I18n.t('helpers.label.report_sheet.zi_o')
          cell I18n.t('helpers.label.report_sheet.go')
          cell I18n.t('helpers.label.report_sheet.oz')
        end

        report_sheets.each do |rs|
          row do
            cell rs.orchestra.member.mglnr
            cell rs.year
            cell rs.children
            cell rs.teens
            cell rs.youth
            cell rs.adult
            cell rs.senior
            cell rs.uv
            cell rs.zusatz_uv
            cell rs.gema
            cell rs.azubi
            cell rs.passive
            cell rs.child_ens
            cell rs.youth_ens
            cell rs.adult_ens
            cell rs.senior_ens
            cell rs.chamber_ens
            cell rs.other_ens
            cell rs.azubi_child
            cell rs.azubi_teens
            cell rs.azubi_youth
            cell rs.azubi_adult
            cell rs.azubi_senior
            cell rs.supporters
            cell rs.zo
            cell rs.zi_o
            cell rs.go
            cell rs.oz
          end
        end
      end
    end
  end

  def find_booking
    bookings = orchestra.member.member_account_bookings.where(booking_year: year, booking_type: 'B')
    return unless !bookings.nil? && (bookings.count >= 1)

    bookings.first
  end

  def orchestra_members_to_age_categories(orchestra_members)
    age_categories = ReportSheet.age_categories
    ages = {}

    age_categories.each do |c|
      ages[c] = 0
    end

    orchestra_members.each do |m|
      ages[m.age_category(year)] += 1
    end

    ages
  end

  def update_from_orchestra_members(orchestra_members)
    orchestra_members_to_age_categories(orchestra_members)

    update_from_age_categories
  end

  def update_from_age_categories(age_categories)
    self.children = age_categories['C']
    self.teens = age_categories['T']
    self.youth = age_categories['Y']
    self.adult = age_categories['A']
    self.senior = age_categories['S']
    save
  end

  def is_consistent_with_age_categories(age_categories)
    return false if self.children != age_categories['C']
    return false if self.teens != age_categories['T']
    return false if self.youth != age_categories['Y']
    return false if self.adult != age_categories['A']
    return false if self.senior != age_categories['S']

    true
  end

  def update_from_orchestra_members(orchestra_members)
    age_categories = orchestra_members_to_age_categories(orchestra_members)

    update_from_age_categories(age_categories)
  end

  def is_consistent?
    @age_categories = orchestra_members_to_age_categories(orchestra.orchestra_members)

    if is_consistent_with_age_categories(@age_categories)
      true
    else
      false
    end
  end

  def is_invoiced?
    !find_booking.nil?
  end

  def invoice_delta
    booking = find_booking

    if booking.nil?
      0
    else
      invoice = orchestra.gen_invoice(year)
      booking.amount + invoice.sum
    end
  end

  def at_least_one_member
    return unless !orchestra.nil? && !orchestra.is_coop?

    return unless calcGemaCount <= 0

    errors.add(:adult, I18n.t('errors.report_sheet.at_least_one'))
  end

  #	TODO: def scoped for easier retrieval!
  #   def orchestras
  #    Orchestra.scoped(:joins => {:user => :memberships}, :conditions => { :memberships => { :group_id => id } })
  #   end
end
