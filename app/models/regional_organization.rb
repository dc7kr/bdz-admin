class RegionalOrganization < ApplicationRecord
  include Authority::Abilities

  has_one :member, as: :member_entity
  accepts_nested_attributes_for :member

  has_many :functions

  has_many :members

  ##  has_many :orchestras, {
  #    :through => :members,
  #    :source => :member_entity,
  #    :source_type => "Orchestra"
  #  }

  #  has_many :person_members, {
  #    :through => :members,
  #    :source => :member_entity,
  #    :source_type => "PersonMember"
  #  }

  # for role based access
  resourcify

  include IbanHelper

  # //validates :blz , :blz => true
  # validates :konto, :konto => true

  def to_s
    name
  end

  def report; end

  def remaining_fee_share_for_year(year:, before: nil)
    minimum = BDZ_SETTINGS['tariff']['lvMinimum']
    percentage = BDZ_SETTINGS['tariff']['lvPart']

    fees = member_fees_for_year(year, before)

    fees.share(percentage: percentage, minimum: minimum)
  end

  def member_fees_for_year(year: nil, before: nil)
    year = Time.zone.now.year if year.nil?

    before = Time.zone.now if before.nil?

    share = FeeShares.new(regional_organization: self, year: year)

    orch_ids = []

    @sheets = ReportSheet.final(year).includes(orchestra: [:member]).where('year = ? and report_date < ? ', year,
                                                                           before)
    @sheets.each do |s|
      orch = s.orchestra

      if s.orchestra.nil?
        Rails.logger.warn("Reportsheet with null orchestra found and skipped: #{s.id}orchestra_id: #{s.orchestra_id}")
        next
      end

      next unless (orch.member.regional_organization_id == id) && orch.member.zero_member_fee_balance?

      orch_ids << orch.member.mglnr

      if s.orchestra.is_direct_debit?
        share.direct_debit.insurance += s.calcUV
        share.direct_debit.orchestras += s.calcBeitrag
      else
        share.invoiced.insurance += s.calcUV
        share.invoiced.orchestras += s.calcBeitrag
      end
    end

    PersonMember.with_zero_balance(true).includes(:member).where(members: { regional_organization_id: id.to_s }).find_each do |p|
      if p.is_direct_debit?
        share.direct_debit.persons += p.tariff.amount
      else
        share.invoiced.persons += p.tariff.amount
      end
    end

    share
  end

  def iban_calc
    compute_iban(konto, blz)
  end

  def pseudo?
    member.nil?
  end

  def currentMagazines(override = false)
    return BDZ_SETTINGS['tariff']['lvZtgCount'].to_i unless override
    return member.magazines if member.magazines >= 0

    BDZ_SETTINGS['tariff']['lvZtgCount'].to_i
  end

  def to_customer
    if member.nil?
      Rails.logger.info("Skipping pseudo LV #{name}")
      return nil
    end

    customer = CorikaInvoices::Customer.new

    customer.customer_id = "LV#{nummer}"
    customer.company = "Bund Deutscher Zupfmusiker e.V. LV #{name}"
    customer.direct_debit = true
    customer.iban = member.iban
    customer.bic = member.bic
    customer
  end

  def magazine_address_list_row
    mag_count = currentMagazines(true)
    return unless mag_count.positive?

    {
      mglnr: member.mglnr,
      company: "Bund Deutscher Zupfmusiker LV #{name}",
      fullname: member.fullname,
      department: '',
      street: member.strasse,
      countryCode: member.country_code,
      zip: member.plz,
      city: member.ort,
      country: member.country_code,
      magazines: mag_count
    }
  end
end
