class AddInstrumentToOrchestraMembers < ActiveRecord::Migration[4.2]
  def change
      add_column :orchestra_members, :instrument, :string
  end
end
