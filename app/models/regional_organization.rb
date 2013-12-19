class RegionalOrganization < ActiveRecord::Base

	self.table_name = 'landesverband'
  #//validates :blz , :blz => true
  #validates :konto, :konto => true

  def to_s
    name
  end

  def member_fee_share_for_year(year,before = nil) 

		if before == nil then
      before = Time.new
    end

		share = Hash.new
		share[:regional_organization]=this
		share[:uv]= 0
		share[:orch_part]= 0
		share[:em_part]= 0
		share[:sum]= 0
		share[:dd_sum]= 0
		share[:dd_part]= 0
		share[:dd_uv]= 0

		@sheets = ReportSheet.final(@curYear).includes([:orchestra]).where("year = ? and report_date < ? ",@curYear, @before)
		@sheets.each do |s|
			if s.orchestra.regional_organization_id == self.id then
	      share[:uv]+= s.calcUV
	      share[:orch_part]+= s.calcLvPart
				share[:sum]+= s.calcBeitrag

				if s.orchestra.is_direct_debit? then
					share[:dd_uv]+=s.calcUV
					share[:dd_sum]+=s.calcBeitrag
					share[:dd_part]+=s.calcLvPart
				end
			end
		end

    PersonMember.with_zero_balance(true).whereere("regional_organization_id = ?",self.id.to_s).each do |p|
      share[:em_part]+=p.tariff.amount
      share[:em_part]+=p.tariff.amount

      if p.is_direct_debit? then
        share[:dd_part]+=p.tariff.amount
      end
    end
    return share
  end
end
