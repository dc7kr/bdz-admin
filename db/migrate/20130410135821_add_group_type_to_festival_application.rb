class AddGroupTypeToFestivalApplication < ActiveRecord::Migration
  def change
    add_column :festival_applications, :group_type, :string
  end
end
