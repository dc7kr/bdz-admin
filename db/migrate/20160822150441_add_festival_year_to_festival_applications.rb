class AddFestivalYearToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :festival_year, :integer
  end
end
