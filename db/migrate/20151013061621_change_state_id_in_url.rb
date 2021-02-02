class ChangeStateIdInUrl < ActiveRecord::Migration[4.2]
  def up
    change_column :urls,:bland_id, :string
    rename_column :urls,:bland_id, :state
  end

  def down
  end
end
