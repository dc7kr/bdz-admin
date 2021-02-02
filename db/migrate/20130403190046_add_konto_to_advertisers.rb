class AddKontoToAdvertisers < ActiveRecord::Migration[4.2]
  def change
    add_column :advertisers, :konto, :string
    add_column :advertisers, :iban, :string
    add_column :advertisers, :blz, :string
  end
end
