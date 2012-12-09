class AddMglnrToOrchestraMembers < ActiveRecord::Migration
  def change
    add_column :orchestra_members, :mglnr, :integer

  end
end
