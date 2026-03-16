class AddProgramItemToFestivalApplication < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_applications, :program_item, :integer
    add_column :festival_applications, :stage_timeslot, :integer
  end
end
