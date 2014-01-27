class MailingFile
  attr_accessor :filename, :orig_filename

  def initialize(filename,orig_filename)
    @filename = filename
    @orig_filename = orig_filename
  end
end
  
