class AddMglnrToConcerts < ActiveRecord::Migration[4.2]
  def change
    add_column :concerts, :mglnr, :integer
  end
end
