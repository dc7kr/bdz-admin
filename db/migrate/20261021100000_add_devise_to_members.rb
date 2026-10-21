# Orchestras and person members sign in to the member area (/mgl) as Member,
# without a separate User, see docs/member_area.md.
class AddDeviseToMembers < ActiveRecord::Migration[7.2]
  def change
    change_table :members, bulk: true do |t|
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :webauthn_id, collation: "ascii_bin"
    end

    add_index :members, :reset_password_token, unique: true
    add_index :members, :webauthn_id, unique: true
  end
end
