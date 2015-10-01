class AddMemberToOrchestras < ActiveRecord::Migration
  def change
    add_column :orchestras, :member_id, :integer
    add_column :orchestras, :orch_type, :string
  end
end
