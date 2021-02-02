class AddStageTimeToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :stage_time, :time
  end
end
