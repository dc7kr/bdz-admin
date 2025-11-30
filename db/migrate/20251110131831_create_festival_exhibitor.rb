class CreateFestivalExhibitor < ActiveRecord::Migration[7.2]
  def change
    create_table :festival_exhibitors do |t|
      t.integer :year, null: false
      t.integer :special_tariff, default: 0 
      t.float   :special_amount, default: 0.0
      t.integer :tariff
      t.timestamps
    end
  end
end
