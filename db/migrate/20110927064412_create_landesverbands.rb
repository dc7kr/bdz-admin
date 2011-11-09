class CreateLandesverbands < ActiveRecord::Migration
  def change
    create_table :landesverbands do |t|
      t.integer :nummer
      t.string :name
      t.string :subname
      t.string :homepage
      t.string :jugendurl

      t.timestamps
    end
  end
end
