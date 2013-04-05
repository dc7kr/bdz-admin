class AddKontoToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :konto, :string
    add_column :advertisers, :iban, :string
    add_column :advertisers, :blz, :string
  end
end
