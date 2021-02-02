class AddCustomerNumberToAdvertiser < ActiveRecord::Migration[4.2]
  def change
    add_column :advertisers, :customer_number, :string
  end
end
