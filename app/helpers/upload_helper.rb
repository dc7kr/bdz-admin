module UploadHelper

  def storeUploadedFile(target_dir,target_name, datafile)
    storage_root = DOCS_CONFIG.archive_dir

    path = File.join(target_dir,target_name)
    full_path = File.join(storage_root,path)

    File.open(full_path, "wb") { 
      |f| f.write(datafile.read)
    }

    return MailingFile.new(path, datafile.original_filename)   
  end

  def readDataFile(datafile)
	  if ( datafile ) then 
		  return datafile.read
	  else
		  return nil
	  end
  end
end
