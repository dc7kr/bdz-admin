class AddContactPhoneToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :contact_phone, :string, :null=>true
  end
end
