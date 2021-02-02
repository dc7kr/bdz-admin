class AddStateToUniversities < ActiveRecord::Migration[4.2]
  def change
    add_column :universities, :state, :string
  end
end
