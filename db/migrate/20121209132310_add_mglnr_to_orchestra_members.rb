class AddMglnrToOrchestraMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :orchestra_members, :mglnr, :integer

  end
end
