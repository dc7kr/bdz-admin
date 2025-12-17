class AddTagToTarrifs < ActiveRecord::Migration[7.2]
  def change
    add_column :tariffs, :tag, :string
  end
end
