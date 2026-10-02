class CreatePasskeys < ActiveRecord::Migration[7.2]
  def up
    create_table :passkeys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :label, null: false
      # base64 credential ids are case sensitive -> binary collation
      t.string :external_id, null: false, collation: binary_collation
      t.text :public_key, null: false
      t.integer :sign_count, null: false, default: 0
      t.datetime :last_used_at

      t.timestamps
    end
    add_index :passkeys, :external_id, unique: true
    add_index :passkeys, [ :user_id, :label ], unique: true

    add_column :users, :webauthn_id, :string, collation: binary_collation
    User.reset_column_information
    User.find_each { |u| u.update_column(:webauthn_id, WebAuthn.generate_user_id) }
    add_index :users, :webauthn_id, unique: true
  end

  # MySQL compares strings case insensitively unless a binary collation is used;
  # SQLite's default collation (BINARY) is case sensitive already
  def binary_collation
    "ascii_bin" if connection.adapter_name.match?(/mysql|trilogy/i)
  end

  def down
    remove_index :users, :webauthn_id
    remove_column :users, :webauthn_id
    drop_table :passkeys
  end
end
