class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.integer :tariff_type
      t.string :description
      t.double :amount

      t.timestamps
    end
  end
end
