class AddMglnrToEnsemble < ActiveRecord::Migration
  def change
    add_column :ensembles, :mglnr, :integer
  end
end
