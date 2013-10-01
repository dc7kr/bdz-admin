class AddConcertDataToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :festival_concert_id, :integer
  end
end
