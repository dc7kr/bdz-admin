class RenameLandesverbandToRegionalOrganization < ActiveRecord::Migration[4.2]
  def up
    rename_table :landesverband, :regional_organizations
  end

  def down
    rename_table :regional_organizations, :landesverband
  end
end
