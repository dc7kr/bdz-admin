class RegionalOrganization < ActiveRecord::Base

	self.table_name = 'landesverband'
  #//validates :blz , :blz => true
  #validates :konto, :konto => true

  def to_s
    name
  end
end
