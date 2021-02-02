class CreateDistinctions < ActiveRecord::Migration[4.2]
  def change
    create_table :distinctions do |t|
      t.date    :dist_date
      t.integer :needles
      t.integer :certificates
      t.integer :honorletters
      t.integer :medals
      t.references :orchestra

      t.timestamps
    end
    add_index :distinctions, :orchestra_id
  end
end
