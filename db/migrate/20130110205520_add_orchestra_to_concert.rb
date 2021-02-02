class AddOrchestraToConcert < ActiveRecord::Migration[4.2]
  def change
    add_column :concerts, :orchestra_id, :integer, :null => true
  end
end
