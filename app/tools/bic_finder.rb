require 'bankleitzahl' 

class BicFinder

  @parser
  def initialize
    blzfile = Rails.root.join('data','blz.txt')
    Rails.logger.debug "Using BLZ file: "+blzfile.to_s
    @lines = File.read(blzfile)
    parser = Bankleitzahl::Parser.new(@lines)
    banks = parser.all_banks

    @bankhash = Hash.new
    @bichash = Hash.new

    banks.each do |b|
      if not b.bic.empty? and not b.bic.strip.empty? 
        @bankhash[b.blz]=b
        @bichash[b.bic] = b
      end
    end
  end

  def exists?(bic)
    if bic.nil? or bic.empty? or bic.length <8
      return false
    end
  
    found = not(@bichash[bic].nil?)

    if found
      return true
    end

    # strip freely definable parts and replace with "XXX"
    tmp = bic[0..7]+"XXX"
    return not(@bichash[tmp].nil?)
  end


  def get_bank(bic)
    @bichash[bic] 
  end

  def bic_for_blz(blz)
     if blz.nil? then
        return nil;
      end

      bank = @bankhash[blz]

      if not bank.nil? then 
        return bank.bic
      end
  end
end
