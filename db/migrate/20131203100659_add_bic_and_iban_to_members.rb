class AddBicAndIbanToMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :bic, :string
    add_column :members, :iban, :string
  end
end
