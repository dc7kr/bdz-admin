class AddExtraTablesToFestivalExhibitors < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_exhibitors, :extra_tables, :integer
  end
end
