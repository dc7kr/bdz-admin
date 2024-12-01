class AddYearToFestivalApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :festival_applications, :year, :integer
  end
end
