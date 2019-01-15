class AddDsgvoConfirmToMembers < ActiveRecord::Migration
  def change
    add_column :members, :dsgvo, :boolean
    add_column :members, :dsgvo_date, :datetime
  end
end
