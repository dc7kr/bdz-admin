class AddBicAndIbanToMembers < ActiveRecord::Migration
  def change
    add_column :members, :bic, :string
    add_column :members, :iban, :string
  end
end
