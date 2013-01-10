class AddPortoToDistinctions < ActiveRecord::Migration
  def change
    add_column :distinctions, :porto, :float

  end
end
