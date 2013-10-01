class AddCustomerNumberToAdvertiser < ActiveRecord::Migration
  def change
    add_column :advertisers, :customer_number, :string
  end
end
