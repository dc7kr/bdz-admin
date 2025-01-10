class FeeShares
  attr_accessor :persons, :orchestras, :insurance,
                :direct_debit, :invoiced, :regional_organization,
                :pre_paid, :year, :leaf

  def initialize(regional_organization: nil, year: Time.now.year, leaf: false)
    self.direct_debit = FeeShares.new(year: year, leaf: true) unless leaf
    self.invoiced = FeeShares.new(year: year, leaf: true) unless leaf

    self.leaf = leaf
    self.year = year
    self.insurance = 0
    self.orchestras = 0
    self.persons = 0
    self.regional_organization = regional_organization

    return unless !regional_organization.nil? and !regional_organization.member.nil?

    self.pre_paid = regional_organization.member.member_account_bookings.where(
      "booking_year = ? and booking_type= 'G'", year
    ).sum(:amount)
  end

  def leaf?
    leaf
  end

  def total
    if leaf?
      persons + orchestras
    else
      direct_debit.total + invoiced.total
    end
  end

  def insurance_total
    if leaf?
      insurance
    else
      direct_debit.insurance + invoiced.insurance
    end
  end

  def persons_total
    if leaf
      persons
    else
      direct_debit.persons + invoiced.persons
    end
  end

  def persons_share
    persons_total * BDZ_SETTINGS['tariff']['lvPart']
  end

  def orchestras_total
    if leaf
      orchestras
    else
      direct_debit.orchestras + invoiced.orchestras
    end
  end

  def orchestras_share
    orchestras_total * BDZ_SETTINGS['tariff']['lvPart']
  end

  def is_corrected?
    uncorr = _share

    uncorr < BDZ_SETTINGS['tariff']['lvMinimum']
  end

  def _share(corrected = false)
    percentage = BDZ_SETTINGS['tariff']['lvPart']

    minimum = 0

    minimum = BDZ_SETTINGS['tariff']['lvMinimum'] if corrected

    val = total * percentage

    if val < minimum
      minimum
    else
      val
    end
  end

  def real_share
    _share
  end

  def corrected_share
    _share(true)
  end
end
