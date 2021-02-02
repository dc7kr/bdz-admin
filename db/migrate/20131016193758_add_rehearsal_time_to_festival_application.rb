class AddRehearsalTimeToFestivalApplication < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :rehearsal_time, :datetime
  end
end
