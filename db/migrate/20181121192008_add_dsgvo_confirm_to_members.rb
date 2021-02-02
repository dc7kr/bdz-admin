class AddDsgvoConfirmToMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :dsgvo, :boolean
    add_column :members, :dsgvo_date, :datetime
  end
end
