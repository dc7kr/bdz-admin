class CreateFestivalApplicationAttachments < ActiveRecord::Migration
  def change
    create_table :festival_application_attachments do |t|
      t.string :name

      t.timestamps
    end
  end
end
