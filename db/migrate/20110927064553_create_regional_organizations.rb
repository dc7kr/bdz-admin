class CreateRegionalOrganizations < ActiveRecord::Migration
  def change
    create_table :regional_organizations do |t|
      t.integer :nummer
      t.string :name
      t.string :subname
      t.string :homepage
      t.string :jugendurl

      t.timestamps
    end
  end
end
