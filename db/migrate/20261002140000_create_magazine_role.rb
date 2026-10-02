# role for editing magazine issues and advertisers, see docs/permissions.md
class CreateMagazineRole < ActiveRecord::Migration[7.2]
  def up
    Role.find_or_create_by!(name: "magazine", resource_type: nil, resource_id: nil)
  end

  def down
    Role.where(name: "magazine", resource_type: nil, resource_id: nil).destroy_all
  end
end
