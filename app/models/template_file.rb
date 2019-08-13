class TemplateFile
  attr_accessor :visible_filename, :orig_filename,:archive_folder

  def self.fromHash(hash)
    if hash.nil?
      nil
    else
      TemplateFile.new(hash["visible_filename"],hash["orig_filename"],hash["archive_folder"])
    end
  end

  def initialize(filename,orig_filename,archive_folder=nil)
    @visible_filename = filename
    @orig_filename = orig_filename

    if  archive_folder.nil? then
      @archive_folder = ""
    else
      @archive_folder = archive_folder.to_s
    end
  end

  def full_dir
    File.join(DOCS_CONFIG.template_dir,@archive_folder)
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
  
