require 'fileutils'
module UploadHelper
  def store_uploaded_file(target_dir, target_name, datafile)
    storage_root = DOCS_CONFIG.archive_dir

    dir_path = File.join(storage_root,target_dir)

    if not Dir.exist?(dir_path)
      FileUtils.mkdir_p(dir_path)
    end

    full_path = File.join(dir_path, target_name)

    File.binwrite(full_path, datafile.read)

    MailingFile.new(target_name, datafile.original_filename)
  end

  def read_data_file(datafile)
    return datafile.read if datafile
    nil
  end
end
