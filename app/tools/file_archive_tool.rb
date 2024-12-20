require "fileutils" 

class FileArchiveTool
  attr_accessor :settings, :timestamp

  def initialize(settings)
    self.settings = settings
    self.timestamp = Time.now.strftime '%Y%m%d%H%M%S'
  end

  def archive_file(srcdir, filename, year)

    target = MailingFile.new(filename,filename,year)

    src_file_name = File.join(srcdir, filename)

    if not File.exists? srcFileName 
      raise DocumentGenerationException("File does not exist: #{src_file_name}")
    end

    Rails.logger.debug("move #{srcFileName} to #{target.full_path}")
    FileUtils.mv(srcFileName, target.full_path)

    return target
  end

  # all parameters are MailingFile instances!
  def merge_pdfs(to_merge,out_file)

    pdftk_exe = self.settings.pdftk

    if not File.exist?(pdftk_exe)
      raise ConfigError("pdftk binary does not exist: #{pdftk_exe}")
    end
     
    Dir.chdir(out_file.full_dir)

    cmd = "#{pdftk_exe} #{to_merge.join(" ")} output #{out_file.full_path}"
    Rails.logger.debug("exec: #{cmd}")
    system(cmd)
  end
end
