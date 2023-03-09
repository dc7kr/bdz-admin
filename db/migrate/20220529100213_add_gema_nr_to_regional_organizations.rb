class AddGemaNrToRegionalOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :regional_organizations, :gema_kdnr, :string
    add_column :regional_organizations, :gema_kdnr_new, :string
  end
end
