class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.integer :advert_type
      t.integer :address_id

      t.timestamps
    end
  end
end
