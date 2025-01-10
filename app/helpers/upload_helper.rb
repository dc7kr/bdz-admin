module UploadHelper
  def storeUploadedFile(target_dir, target_name, datafile)
    storage_root = DOCS_CONFIG.archive_dir

    path = File.join(target_dir, target_name)
    full_path = File.join(storage_root, path)

    File.binwrite(full_path, datafile.read)

    MailingFile.new(path, datafile.original_filename)
  end

  def readDataFile(datafile)
    return datafile.read if datafile

    nil
  end
end
