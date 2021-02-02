class AddIbanAndBicToRegionalOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :regional_organizations, :iban, :string
    add_column :regional_organizations, :bic, :string
  end
end
