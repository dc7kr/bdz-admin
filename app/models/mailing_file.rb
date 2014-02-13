class MailingFile
  attr_accessor :visible_filename, :orig_filename,:archive_folder

  def initialize(filename,orig_filename,archive_folder=nil)
    @visible_filename = filename
    @orig_filename = orig_filename

    if  archive_folder.nil? then
      @archive_folder = Time.now.year.to_s
    else
      @archive_folder = archive_folder.to_s
    end
  end

  def full_dir
    File.join(BDZ_SETTINGS["invoice_archive_dir"],@archive_folder)
  end

  def relative_filename
    return File.join(@archive_folder,@orig_filename)
  end

  def full_path
      return File.join(full_dir,@orig_filename)
  end

  def to_s
    full_path
  end
end
  
