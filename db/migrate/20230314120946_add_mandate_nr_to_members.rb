class AddMandateNrToMembers < ActiveRecord::Migration[5.2]
  def up
    add_column :members, :sepa_mandate_nr, :string

  end

  def down
    remove_column :members, :sepa_mandate_nr
  end
end
