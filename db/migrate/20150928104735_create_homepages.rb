class CreateHomepages < ActiveRecord::Migration
  def change
    create_table :homepages do |t|
      t.string :abbrev, :limit=>20
      t.string :mitglnr, :limit=>6
      t.string :name, :limit=>100
      t.string :kontakt
      t.string :proben
      t.string :descr
      t.datetime :created
      t.date :lastchange
      t.string :redir_url
      t.timestamps
    end
  end
end
