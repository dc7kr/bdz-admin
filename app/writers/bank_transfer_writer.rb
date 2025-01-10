class BankTransferWriter
  attr_accessor :date_prefix, :outfile, :workdir

  def initialize(date_prefix = nil, _workdir)
    self.date_prefix = if date_prefix.nil?
                         Time.now.strftime '%Y%m%d%H%M%S'
                       else
                         date_prefix
                       end
  end

  def overrideDate(pref)
    self.date_prefix = pref + '_'
  end
end
