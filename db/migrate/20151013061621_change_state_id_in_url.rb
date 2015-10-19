class ChangeStateIdInUrl < ActiveRecord::Migration
  def up
    change_column :urls,:bland_id, :string
    rename_column :urls,:bland_id, :state
  end

  def down
  end
end
