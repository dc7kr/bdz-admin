class RenameContactIdDeprecated < ActiveRecord::Migration[4.2]
  def change
    rename_column :board_contacts, :contact_id, :contact_id_off
  end
end
