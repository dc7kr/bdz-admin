class AddAttachmentAttachedFileToFestivalApplicationAttachments < ActiveRecord::Migration
  def self.up
    change_table :festival_application_attachments do |t|
      t.attachment :attached_file
    end
  end

  def self.down
    drop_attached_file :festival_application_attachments, :attached_file
  end
end
