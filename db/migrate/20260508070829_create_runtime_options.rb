class CreateRuntimeOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :runtime_options do |t|
      t.string :key
      t.boolean :bool_value
      t.datetime :datetime_value
      t.string :string_value
      t.string :value_type

      t.timestamps
    end
  end
end
