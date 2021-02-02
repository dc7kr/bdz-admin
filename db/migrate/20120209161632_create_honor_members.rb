class CreateHonorMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :honor_members do |t|
      t.integer :nr
      t.string :vorname
      t.string :name
      t.string :ort
      t.string :honorType
      t.date :honorDate

      t.timestamps
    end
  end
end
