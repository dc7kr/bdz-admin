class ChangeDurationToTimeField < ActiveRecord::Migration[7.2]
  def change
    rename_column :festival_pieces, :duration, :duration_txt
    add_column :festival_pieces, :duration, :time
  end
end
