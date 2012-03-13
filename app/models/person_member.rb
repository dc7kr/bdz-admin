class PersonMember < ActiveRecord::Base
  inherits_from :member
  belongs_to :tariff

  def self.search(search)
	if (search)
		where('members.mglnr = ? or person_members.nachname like ?',"#{search}","%#{search}%")
	else
		scoped
	end
  end
end
