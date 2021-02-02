class AddFestivalApplicationIdToFestivalApplicationAttachment < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_application_attachments, :festival_application_id, :integer
  end
end
