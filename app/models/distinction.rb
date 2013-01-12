class Distinction < ActiveRecord::Base
  belongs_to :orchestra
  belongs_to :member_account_booking

  def calcSum 
	sum = 0

	if ( silver_needles != nil ) then
		sum+=Prices.silverNeedle*silver_needles
	end

	if (gold_needles != nil ) then 
		sum+= Prices.goldenNeedle*gold_needles
	end
	if (honorletters != nil ) then 
		sum+=Prices.honorLetter*honorletters
	end
	if (certificates != nil) then
		sum+=Prices.certificate*certificates
	end
	if (national_needles != nil ) then
		sum+=Prices.nationalNeedle*national_needles
	end

	p = 0 
	if (porto == nil ) then
		p = Prices.distinctionPorto
	else 
		p = porto
	end
	sum+=p
  end

end
