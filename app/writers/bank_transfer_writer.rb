class BankTransferWriter
  attr_accessor :datePrefix, :outfile

	def self.workdir
		BDZ_SETTINGS['invoice_workdir']+"/"
	end


	def initialize(datePrefix=nil)
    if datePrefix.nil? then
      @datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    else
		  @datePrefix=datePrefix
    end
	end

	def overrideDate(pref)
		@datePrefix=pref+"_"
	end
end
