class CreateMagazineSamplings < ActiveRecord::Migration
  def change
    create_table :magazine_samplings do |t|
      t.integer :count
      t.integer :address_id

      t.timestamps
    end
  end
end
