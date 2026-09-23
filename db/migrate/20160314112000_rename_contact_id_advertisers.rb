class RenameContactIdAdvertisers < ActiveRecord::Migration[4.2]
  def up
    rename_column :advertisers, :address_id, :contact_id_off
  end

  def down
  end
end
