class AddStateToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :state, :string
  end
end
