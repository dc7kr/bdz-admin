class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.references :category
      t.string :url
      t.string :titel
      t.string :descr
      t.string :sprache
      t.references :land
      t.references :bland
      t.string :user
      t.string :email
      t.datetime :lastchange
      t.datetime :confirmed
      t.boolean :visible
      t.string :ip

      t.timestamps
    end
    add_index :urls, :bland_id
  end
end
