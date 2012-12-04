class CreateRegionalOrganizationBookings < ActiveRecord::Migration
  def change
    create_table :regional_organization_bookings do |t|
      t.references :regional_organization
      t.string :booking_type
      t.integer :booking_year
      t.string :booking_mode
      t.datetime :booking_date
      t.string :booking_txt
      t.string :filename
      t.float :amount

      t.timestamps
    end
    add_index :regional_organization_bookings, :regional_organization_id
  end
end
