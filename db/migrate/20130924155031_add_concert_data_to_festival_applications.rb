class AddConcertDataToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :festival_concert_id, :integer
  end
end
