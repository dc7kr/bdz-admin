class AddStageTimeToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :stage_time, :time
  end
end
