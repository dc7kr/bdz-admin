class RenameRegionalOrganizationReference < ActiveRecord::Migration
  def up
    rename_column :functions, :lv_id, :regional_organization_id
  end

  def down
  end
end
