class AddFestivalYearToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :festival_year, :integer
  end
end
