class AddBicAndIbanToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :bic, :string
    add_column :contacts, :iban, :string
  end
end
