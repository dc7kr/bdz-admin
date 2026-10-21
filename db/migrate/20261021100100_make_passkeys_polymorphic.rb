# Passkeys belong to a User (staff) or a Member (member area).
class MakePasskeysPolymorphic < ActiveRecord::Migration[7.2]
  def up
    remove_foreign_key :passkeys, :users
    remove_index :passkeys, name: "index_passkeys_on_user_id_and_label"
    remove_index :passkeys, name: "index_passkeys_on_user_id"

    rename_column :passkeys, :user_id, :owner_id
    add_column :passkeys, :owner_type, :string, null: false, default: "User"
    change_column_default :passkeys, :owner_type, from: "User", to: nil

    add_index :passkeys, %i[owner_type owner_id]
    add_index :passkeys, %i[owner_type owner_id label], unique: true, name: "index_passkeys_on_owner_and_label"
  end

  def down
    raise ActiveRecord::IrreversibleMigration if select_value("select count(*) from passkeys where owner_type <> 'User'").to_i.positive?

    remove_index :passkeys, name: "index_passkeys_on_owner_and_label"
    remove_index :passkeys, %i[owner_type owner_id]
    remove_column :passkeys, :owner_type
    rename_column :passkeys, :owner_id, :user_id
    add_index :passkeys, :user_id
    add_index :passkeys, %i[user_id label], unique: true, name: "index_passkeys_on_user_id_and_label"
    add_foreign_key :passkeys, :users
  end
end
