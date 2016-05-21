class RenameContactIdDeprecated < ActiveRecord::Migration
  def change
    rename_column :board_contacts, :contact_id, :contact_id_off
  end
end
