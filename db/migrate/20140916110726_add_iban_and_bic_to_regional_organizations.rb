class AddIbanAndBicToRegionalOrganizations < ActiveRecord::Migration
  def change
    add_column :regional_organizations, :iban, :string
    add_column :regional_organizations, :bic, :string
  end
end
