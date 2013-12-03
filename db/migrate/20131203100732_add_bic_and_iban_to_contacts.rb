class AddBicAndIbanToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :bic, :string
    add_column :contacts, :iban, :string
  end
end
