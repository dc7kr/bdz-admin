class BankTransferWriter
  attr_accessor :date_prefix, :outfile,:workdir

	def initialize(date_prefix=nil, workdir)
    if date_prefix.nil? then
      self.date_prefix = Time.now.strftime '%Y%m%d%H%M%S'
    else
		  self.date_prefix=date_prefix
    end
	end

	def overrideDate(pref)
		self.date_prefix=pref+"_"
	end
end
