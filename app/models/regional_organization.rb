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

  #//validates :blz , :blz => true
  #validates :konto, :konto => true

  def to_s
    name
  end

  def report 


  end

  def remaining_fee_share_for_year(year:, before: nil)
    minimum = BDZ_SETTINGS['tariff']['lvMinimum']
    percentage = BDZ_SETTINGS['tariff']['lvPart']

    fees = member_fees_for_year(year,before)

    share = fees.share(percentage: percentage, minimum: minimum)
  end

  def member_fees_for_year(year: nil,before: nil) 

    if year.nil? then
      year = Time.now.year
    end

    if before.nil? then
      before = Time.now
    end

    share = FeeShares.new(regional_organization: self,year: year)

    orch_ids = Array.new

    @sheets = ReportSheet.final(year).includes(orchestra: [ :member ]).where("year = ? and report_date < ? ",year, before)
    @sheets.each do |s|
      orch = s.orchestra

      if s.orchestra.nil?
        Rails.logger.warn("Reportsheet with null orchestra found and skipped: "+s.id.to_s+ "orchestra_id: "+s.orchestra_id.to_s) 
        next
      end

      if orch.member.regional_organization_id == self.id and orch.member.zero_member_fee_balance? then
          orch_ids << orch.member.mglnr

          if s.orchestra.is_direct_debit?
              share.direct_debit.insurance += s.calcUV
              share.direct_debit.orchestras += s.calcBeitrag
          else
              share.invoiced.insurance += s.calcUV
              share.invoiced.orchestras += s.calcBeitrag
          end
      end
    end

    em_ids = Array.new

    PersonMember.with_zero_balance(true).includes(:member).where("members.regional_organization_id = ?",self.id.to_s).each do |p|
      
      if p.is_direct_debit?
          share.direct_debit.persons += p.tariff.amount
      else
          share.invoiced.persons += p.tariff.amount
      end
    end

    return share
  end

  def iban_calc
      compute_iban(konto,blz)
  end

  def pseudo?
    member.nil?
  end

  def currentMagazines(override=false)
    if override
      if member.magazines >= 0 
        return member.magazines
      else 
		    return BDZ_SETTINGS["tariff"]["lvZtgCount"].to_i
      end
    else
		    return BDZ_SETTINGS["tariff"]["lvZtgCount"].to_i
    end
  end

  def to_customer

    if member.nil? then 
      Rails.logger.info("Skipping pseudo LV #{name}")
      return nil
    end

    customer = CorikaInvoices::Customer.new

    customer.customer_id = "LV#{nummer}"
    customer.company = "Bund Deutscher Zupfmusiker e.V. LV #{name}"
    customer.direct_debit = true
    customer.iban= member.iban
    customer.bic = member.bic
    customer
  end

  def magazine_address_list_row

      mag_count = currentMagazines(true)
      if (mag_count>0) 
        csvrow = {
			    :mglnr=>member.mglnr,
          :company=> "Bund Deutscher Zupfmusiker LV #{name}",
			    :fullname=>member.fullname,
			    :department=>'',
			    :street=>member.strasse,
			    :countryCode=>member.country_code,
			    :zip=>member.plz,
			    :city=>member.ort,
			    :country=>member.country_code,
			    :magazines=>mag_count
       }

       return csvrow
      else 
        nil
    end
  end

end
