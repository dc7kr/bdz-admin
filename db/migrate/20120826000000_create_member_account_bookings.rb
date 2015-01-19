class CreateMemberAccountBookings < ActiveRecord::Migration
  def change
    create_table "member_account_bookings" do |t|
      t.integer :member_id,      :integer,   :null => false
      t.string :booking_type,   :string, :null => false
      t.integer :booking_year,   :integer,               :null => false
      t.string :booking_mode,   :string, :limit => 1,   :null => false
      t.datetime :booking_date,   :datetime,               :null => false
      t.string :booking_txt,    :string,                :null => false
      t.string :filename,       :string, :limit => 100
      t.float :amount,         :float,               :null => false
    end

    add_index :member_account_bookings, :member_id 
  end

end
