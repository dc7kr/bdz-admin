class RegionalOrganization < ActiveRecord::Base

	set_table_name "landesverband"

  def to_s
    name
  end
end
