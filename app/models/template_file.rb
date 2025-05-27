class TemplateFile
  attr_accessor :visible_filename, :orig_filename, :archive_folder

  def self.fromHash(hash)
    if hash.nil?
      nil
    else
      TemplateFile.new(hash["visible_filename"], hash["orig_filename"], hash["archive_folder"])
    end
  end

  def initialize(filename, orig_filename, archive_folder = nil)
    @visible_filename = filename
    @orig_filename = orig_filename

    @archive_folder = if archive_folder.nil?
                        ""
    else
                        archive_folder.to_s
    end
  end

  def full_dir
    File.join(DOCS_CONFIG.template_dir, @archive_folder)
  end

  def relative_filename
    File.join(@archive_folder, @orig_filename)
  end

  def full_path
    File.join(full_dir, @orig_filename)
  end

  def to_s
    full_path
  end
end
