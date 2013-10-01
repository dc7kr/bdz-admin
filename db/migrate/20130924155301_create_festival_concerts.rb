class CreateFestivalConcerts < ActiveRecord::Migration
  def change
    create_table :festival_concerts do |t|
      t.string :location
      t.datetime :event_time
      t.integer :number

      t.timestamps
    end
  end
end
