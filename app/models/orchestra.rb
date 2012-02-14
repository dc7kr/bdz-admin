class Orchestra < ActiveRecord::Base
  has_many :report_sheets

  inherits_from :member

  def self.search(search)
	if (search)
		where('members.mglnr = ?',"#{search}")
	else
		scoped
	end
  end
end
