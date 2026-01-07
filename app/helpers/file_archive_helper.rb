require "fileutils"

module FileArchiveHelper
  def archive_file(srcdir, filename, year)
    target = MailingFile.new(filename, filename, year)

    src_file_name = File.join(srcdir, filename)

    if File.exist? src_file_name
      Rails.logger.debug { "move #{src_file_name} to #{target.full_path}" }

      if not File.directory? target.full_dir 
        FileUtils.mkdir_p target.full_dir
      end

      FileUtils.mv(src_file_name, target.full_path)
      target
    else
      Rails.logger.error("Source file not found: #{src_file_name}")
      nil
    end
  end

  # all parameters are MailingFile instances!
  def merge_pdfs(to_merge, out_file)
    Dir.chdir(out_file.full_dir)
    cmd = "/usr/bin/pdftk #{to_merge.join(' ')} output #{out_file.full_path}"
    Rails.logger.debug { "exec: #{cmd}" }
    system(cmd)
  end
end
