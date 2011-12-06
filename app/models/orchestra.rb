class Orchestra < ActiveRecord::Base
  belongs_to :regional_organization
  has_many :report_sheet

  def self.search(search)
	if (search)
		where('mglnr like ?',"%#{search}%")
	else
		scoped
	end
  end
end
