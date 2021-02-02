class AddGroupTypeToFestivalApplication < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :group_type, :string
  end
end
