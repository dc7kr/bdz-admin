class ConvertFestivalApplicationTimesToDatetime < ActiveRecord::Migration[7.2]
  def change
    change_column :festival_applications, :stage_time, :datetime
    change_column :festival_applications, :rehearsal_time, :datetime
  end
end
