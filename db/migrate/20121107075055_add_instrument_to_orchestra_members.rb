class AddInstrumentToOrchestraMembers < ActiveRecord::Migration
  def change
      add_column :orchestra_members, :instrument, :string
  end
end
