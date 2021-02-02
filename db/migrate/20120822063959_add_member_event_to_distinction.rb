class AddMemberEventToDistinction < ActiveRecord::Migration[4.2]
  def change
    add_column :distinctions, :member_account_booking_id, :integer
	add_index :distinctions, :member_account_booking_id
  end
end
