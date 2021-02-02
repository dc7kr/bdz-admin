class AddIbanBicToAdvertiser < ActiveRecord::Migration[4.2]
  def change
    rename_column :advertisers, :blz, :bic
    add_column :advertisers, :account_owner, :string
    add_column :advertisers, :direct_debit, :boolean
  end
end
