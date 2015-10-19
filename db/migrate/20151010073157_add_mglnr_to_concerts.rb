class AddMglnrToConcerts < ActiveRecord::Migration
  def change
    add_column :concerts, :mglnr, :integer
  end
end
