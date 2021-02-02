class CreateRegionalOrganizations < ActiveRecord::Migration[4.2]
  def change
    create_table :landesverband do |t|
      t.integer :nummer
      t.string :name
      t.string :subname
      t.string :homepage
      t.string :jugend_url

      t.timestamps
    end
  end
end
