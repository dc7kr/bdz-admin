class Distinction < ActiveRecord::Base
  belongs_to :orchestra
  belongs_to :member_account_booking

  def calcSum 
	Prices.silverNeedle*silver_needles+
	Prices.goldenNeedle*gold_needles+
	Prices.honorLetter*honorletters+
	Prices.certificate*certificates+
	Prices.nationalNeedle*national_needles
  end

end
