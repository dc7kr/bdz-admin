class CreateFestivalPieces < ActiveRecord::Migration[4.2]
  def change
    create_table :festival_pieces do |t|
      t.integer :festival_application_id
      t.string :composer
      t.string :title
      t.time :duration

      t.timestamps
    end
  end
end
