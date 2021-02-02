class AddInstrumentToUniversities < ActiveRecord::Migration[4.2]
  def change
    add_column :universities, :instrument, :string
  end
end
