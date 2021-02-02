class AddContactPhoneToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :contact_phone, :string, :null=>true
  end
end
