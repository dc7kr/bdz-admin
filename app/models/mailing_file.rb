class MailingFile
  attr_accessor :visible_filename, :orig_filename,:archive_folder

  def self.fromHash(hash)
    if hash.nil?
      nil
    else
      MailingFile.new(hash["visible_filename"],hash["orig_filename"],hash["archive_folder"])
    end
  end

  def to_hash
    self.instance_values
  end

  def initialize(filename,orig_filename,archive_folder=nil)
    self.visible_filename = filename
    self.orig_filename = orig_filename

    if  archive_folder.nil? then
      self.archive_folder = Time.now.year.to_s
    else
      self.archive_folder = archive_folder.to_s
    end
  end

  def full_dir
    File.join(INVOICE_CONFIG.archive_dir,self.archive_folder)
  end

  def relative_filename
    return File.join(self.archive_folder,self.orig_filename)
  end

  def full_path
      return File.join(full_dir,self.orig_filename)
  end

  def to_s
    full_path
  end
end
