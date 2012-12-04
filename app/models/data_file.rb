class DataFile < ActiveRecord::Base

  def self.save(targetPrefix,targetDir,upload)
    name =  targetPrefix+upload.original_filename
	if ( targetDir == nil ) then
		targetDir = "public/data"
	end
    full_path = File.join(targetDir, name)
    File.open(full_path, "wb") { |f| f.write(upload.read) }

	full_path
  end

end

