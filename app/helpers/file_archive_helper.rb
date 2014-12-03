require "fileutils" 

module FileArchiveHelper
  def archive_file(srcdir, filename, year)

    target = MailingFile.new(filename,filename,year)

    FileUtils.mv(File.join(srcdir, filename), target.full_path)

    return target
  end

  # all parameters are MailingFile instances!
	def merge_pdfs(to_merge,out_file)

		Dir.chdir(out_file.full_dir)
		cmd = "/usr/bin/pdftk "+to_merge.join(" ")+" output "+out_file.full_path
    Rails.logger.debug("exec: #{cmd}")
		system(cmd)
	end
end
