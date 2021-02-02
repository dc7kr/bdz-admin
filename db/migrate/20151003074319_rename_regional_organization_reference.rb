class RenameRegionalOrganizationReference < ActiveRecord::Migration[4.2]
  def up
    rename_column :functions, :lv_id, :regional_organization_id
  end

  def down
  end
end
