require "fileutils" 

module FileArchiveHelper
  def archive_file(srcdir, filename, year)
    archive_dir = BDZ_SETTINGS["invoice_archive_dir"]

    target = archive_dir+"/"+filename

    FileUtils.mv(srcdir+"/"+filename,target)

    MailingFile.new(filename,target)
  end

	def merge_pdfs(dir,to_merge,out_file)
		Dir.chdir(dir)
		cmd = "/usr/bin/pdftk "+to_merge.join(" ")+" output "+out_file
		system(cmd)
	end
end
