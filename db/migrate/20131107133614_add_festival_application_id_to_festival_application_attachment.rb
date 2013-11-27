class AddFestivalApplicationIdToFestivalApplicationAttachment < ActiveRecord::Migration
  def change
    add_column :festival_application_attachments, :festival_application_id, :integer
  end
end
