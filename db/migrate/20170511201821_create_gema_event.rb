class CreateGemaEvent < ActiveRecord::Migration[4.2]
  def change
    create_table :gema_events do |t|
      t.integer :kdnr
      t.string :name
      t.string :zip
      t.string :city
      t.date :date
      t.string :title
      t.string :tariff
      t.float :amount
      t.string :location
      t.string :location_city
      t.boolean :program_available
      t.string :source
      t.string :par_mgl
      t.string :nf_id
    end
  end
end
