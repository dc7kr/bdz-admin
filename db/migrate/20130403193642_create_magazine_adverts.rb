class CreateMagazineAdverts < ActiveRecord::Migration[4.2]
  def change
    create_table :magazine_adverts do |t|
      t.integer :advertiser_id
      t.integer :magazine_issue_id

      t.timestamps
    end
  end
end
