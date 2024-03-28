class DeleteObsoleteColumnsFromPersonMembers < ActiveRecord::Migration[7.1]
  def up
    remove_column :person_members, :zeitungen
    remove_column :person_members, :zusatzzeitung
  end

  def down
    add_column :person_members, :zeitungen, :integer
    add_column :person_members, :zusatzzeitung, :integer
  end
end
