class AddRehearsalTimeToFestivalApplication < ActiveRecord::Migration
  def change
    add_column :festival_applications, :rehearsal_time, :datetime
  end
end
