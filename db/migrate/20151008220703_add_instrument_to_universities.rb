class AddInstrumentToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :instrument, :string
  end
end
