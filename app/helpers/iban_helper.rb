module IbanHelper
  def compute_iban(konto, blz)
    return nil if [nil, 0].include?(konto) or blz.nil?

    de_suffix = '131400'
    padded_kto = '%010d' % konto
    suffix = blz.to_s + padded_kto + de_suffix
    check_digits = 98 - (suffix.to_i % 97)
    'DE' + ('%02d' % check_digits) + blz.to_s + padded_kto
  end

  def find_bic(_blz)
    bic_finder = BicFinder.new
    bic_finder.bic_for_blz(m.blz)
  end
end
