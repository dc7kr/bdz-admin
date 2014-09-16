module IbanHelper

  def compute_iban(konto,blz) 
    if konto == nil or konto == 0 or blz ==nil 
		  return nil
	  end
  	de_suffix = "131400"
  	padded_kto =  "%010d" % konto
  	suffix = blz.to_s+ padded_kto+de_suffix
  	check_digits = 98- (suffix.to_i % 97)
  	iban = "DE"+ ("%02d" % check_digits) + blz.to_s+padded_kto

    return iban
  end

  def find_bic(blz)
    bic_finder = BicFinder.new
    bic_finder.bic_for_blz(m.blz)
  end

end
