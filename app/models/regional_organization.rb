class RegionalOrganization < ActiveRecord::Base

	self.table_name = 'landesverband'
  #//validates :blz , :blz => true
  #validates :konto, :konto => true

  def to_s
    name
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

		@sheets = ReportSheet.final(year).includes([:orchestra]).where("year = ? and report_date < ? ",year, before)
		@sheets.each do |s|
      orch = s.orchestra
			if orch.regional_organization_id == self.id and orch.zero_member_fee_balance? then
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

    PersonMember.with_zero_balance(true).includes(:member).where("members.regional_organization_id = ?",self.id.to_s).each do |p|
      share[:em_part]+=p.tariff.calcLvPart

      if p.is_direct_debit? then
        share[:dd_em_part]+=p.tariff.calcLvPart
      end
    end
    return share
  end
end
