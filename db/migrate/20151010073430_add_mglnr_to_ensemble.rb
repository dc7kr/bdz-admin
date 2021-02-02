class AddMglnrToEnsemble < ActiveRecord::Migration[4.2]
  def change
    add_column :ensembles, :mglnr, :integer
  end
end
