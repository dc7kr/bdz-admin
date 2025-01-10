class MailingFile
  attr_accessor :visible_filename, :orig_filename, :archive_folder

  def self.from_hash(hash)
    if hash.nil?
      nil
    else
      MailingFile.new(hash['visible_filename'], hash['orig_filename'], hash['archive_folder'])
    end
  end

  def to_hash
    instance_values
  end

  def initialize(filename, orig_filename, archive_folder = nil)
    self.visible_filename = filename
    self.orig_filename = orig_filename

    self.archive_folder = if archive_folder.nil?
                            Time.now.year.to_s
                          else
                            archive_folder.to_s
                          end
  end

  def full_dir
    File.join(INVOICE_CONFIG.archive_dir, archive_folder)
  end

  def relative_filename
    File.join(archive_folder, orig_filename)
  end

  def full_path
    File.join(full_dir, orig_filename)
  end

  def to_s
    full_path
  end
end
