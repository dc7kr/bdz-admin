class CreateMemberAccountBookings < ActiveRecord::Migration
  def change
    create_table "member_account_bookings" do |t|
      t.integer :member_id,      :null => false
      t.string :booking_type,   :null => false
      t.integer :booking_year,   :null => false
      t.string :booking_mode,   :limit => 1,   :null => false
      t.datetime :booking_date,   :null => false
      t.string :booking_txt,    :null => false
      t.string :filename,       :limit => 100
      t.float :amount,         :null => false
    end

    add_index :member_account_bookings, :member_id 
  end

end
