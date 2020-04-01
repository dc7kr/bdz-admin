class RegionalOrganization < ApplicationRecord
  include Authority::Abilities

  has_one :member, as: :member_entity
  accepts_nested_attributes_for :member
  
  has_many :functions

  has_many :members

   has_many :orchestras, {
    :through => :members,
    :source => :member_entity,
    :source_type => "Orchestra"
  }

  has_many :person_members, {
    :through => :members,
    :source => :member_entity,
    :source_type => "PersonMember"
  }

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

  def member_fee_share_for_year(year=nil,before = nil) 

    if year.nil? then
      year = Time.now.year
    end

		if before.nil? then
      before = Time.now
    end

		share = Hash.new
		share[:regional_organization]=self
		share[:uv]= 0
		share[:orch_part]= 0
		share[:em_part]= 0
		share[:sum]= 0
		share[:dd_orch_sum]= 0
		share[:dd_em_sum]= 0
		share[:dd_em_part]= 0
		share[:dd_orch_part]= 0
		share[:dd_uv]= 0

    pre_paid_sum = 0


    if not member.nil? 
      pre_paid_sum = member.member_account_bookings.where("booking_year = ? and booking_type= 'G'",year).sum(:amount)
    end

    share[:pre_paid]= pre_paid_sum

    share[:orch_ids] = Array.new

		@sheets = ReportSheet.final(year).includes(orchestra: [ :member ]).where("year = ? and report_date < ? ",year, before)
		@sheets.each do |s|
      orch = s.orchestra
      if s.orchestra.nil?
        Rails.logger.warn("Reportsheet with null orchestra found and skipped: "+s.id.to_s+ "orchestra_id: "+s.orchestra_id.to_s) 
        next
      end

			if orch.member.regional_organization_id == self.id and orch.zero_member_fee_balance? then
        share[:orch_ids] << orch.member.mglnr
	      share[:uv]+= s.calcUV
	      share[:orch_part]+= s.calcLvPart
				share[:sum]+= s.calcBeitrag

				if s.orchestra.is_direct_debit? then
					share[:dd_uv]+=s.calcUV
					share[:dd_orch_sum]+=s.calcBeitrag
					share[:dd_orch_part]+=s.calcLvPart
				end
			end
		end


    share[:em_ids] = Array.new

    PersonMember.with_zero_balance(true).includes(:member).where("members.regional_organization_id = ?",self.id.to_s).each do |p|
      share[:em_part]+=p.tariff.calcLvPart
      share[:em_ids] << p.member.mglnr

      if p.is_direct_debit? then
        share[:dd_em_part]+=p.tariff.calcLvPart
      end
    end
    return share
  end

  def iban_calc
      compute_iban(konto,blz)
  end

  def to_customer
    customer = CorikaInvoices::Customer.new

    customer.customer_id = "LV#{nummer}"
    customer.company = "Bund Deutscher Zupfmusiker e.V. LV #{name}"
    customer.direct_debit = true
    customer.iban= member.iban
    customer.bic = member.bic
    customer
  end
end
