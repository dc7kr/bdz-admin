class AddOrchestraToConcert < ActiveRecord::Migration
  def change
    add_column :concerts, :orchestra_id, :integer, :null => true
  end
end
