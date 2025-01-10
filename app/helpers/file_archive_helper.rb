require 'fileutils'

module FileArchiveHelper
  def archive_file(srcdir, filename, year)
    target = MailingFile.new(filename, filename, year)

    srcFileName = File.join(srcdir, filename)

    if File.exist? srcFileName
      Rails.logger.debug { "move #{srcFileName} to #{target.full_path}" }
      FileUtils.mv(srcFileName, target.full_path)
      target
    else
      Rails.logger.error('Source file not found: ' + srcFileName)
      nil
    end
  end

  # all parameters are MailingFile instances!
  def merge_pdfs(to_merge, out_file)
    Dir.chdir(out_file.full_dir)
    cmd = '/usr/bin/pdftk ' + to_merge.join(' ') + ' output ' + out_file.full_path
    Rails.logger.debug { "exec: #{cmd}" }
    system(cmd)
  end
end
