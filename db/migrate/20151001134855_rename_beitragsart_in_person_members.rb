class RenameBeitragsartInPersonMembers < ActiveRecord::Migration[4.2]
  def up
    rename_column :person_members, :beitragsart, :tariff_id
  end

  def down
  end
end
