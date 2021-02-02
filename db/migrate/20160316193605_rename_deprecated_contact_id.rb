class RenameDeprecatedContactId < ActiveRecord::Migration[4.2]
  def up
    rename_column :magazine_samplings, :contact_id, :contact_id_off
  end

  def down
  end
end
