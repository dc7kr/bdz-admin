class DataFile < ApplicationRecord
  def self.save(targetPrefix, targetDir, upload)
    name = targetPrefix + upload.original_filename
    targetDir = 'public/data' if targetDir.nil?
    full_path = File.join(targetDir, name)
    Rails.logger.debug { "Target file: #{full_path}" }
    f = File.open(full_path, 'wb')
    f.write(upload.read)
    f.close

    full_path
  end
end
