require "bankleitzahl"

class BicFinder
  def initialize
    blzfile = Rails.root.join("data/blz.txt")
    Rails.logger.debug { "Using BLZ file: #{blzfile}" }
    @lines = File.read(blzfile)
    parser = Bankleitzahl::Parser.new(@lines)
    banks = parser.all_banks

    @bankhash = {}
    @bichash = {}

    banks.each do |b|
      if !b.bic.empty? && !b.bic.strip.empty?
        @bankhash[b.blz] = b
        @bichash[b.bic] = b
      end
    end
  end

  def valid?(bic)
    if bic.nil?
      false
    else
      ctry = get_country(bic)
      return exist?(bic) if ctry == "DE"

      true

    end
  end

  def get_country(bic)
    if bic.nil?
      nil
    else
      bic[4..5]
    end
  end

  def exist?(bic)
    return false if bic.blank? || (bic.length < 8)

    found = !@bichash[bic].nil?

    return true if found

    # strip freely definable parts and replace with "XXX"
    tmp = "#{bic[0..7]}XXX"
    !@bichash[tmp].nil?
  end

  def get_bank(bic)
    @bichash[bic]
  end

  def bic_for_blz(blz)
    return nil if blz.nil?

    bank = @bankhash[blz]

    return if bank.nil?

    bank.bic
  end
end
