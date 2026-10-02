class ExtendRuntimeOptions < ActiveRecord::Migration[7.2]
  def change
    add_column :runtime_options, :integer_value, :integer
    change_column_null :runtime_options, :key, false
    add_index :runtime_options, :key, unique: true
  end
end
