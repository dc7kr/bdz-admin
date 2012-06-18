class RegionalOrganization < ActiveRecord::Base

	set_table_name "landesverband"
  #//validates :blz , :blz => true
  #validates :konto, :konto => true

  def to_s
    name
  end
end
