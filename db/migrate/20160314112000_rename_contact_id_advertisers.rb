class RenameContactIdAdvertisers < ActiveRecord::Migration
  def up
    rename_column :advertisers, :contact_id, :contact_id_off
  end

  def down
  end
end
