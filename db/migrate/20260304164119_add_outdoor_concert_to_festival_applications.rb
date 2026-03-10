class AddOutdoorConcertToFestivalApplications < ActiveRecord::Migration[7.2]
  def change
    add_reference :festival_applications, :outdoor_concert, null: true, foreign_key: { to_table: :festival_concerts }, type: :integer
  end
end
