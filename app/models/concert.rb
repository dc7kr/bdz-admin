class Concert < ActiveRecord::Base

    scope :public, where('visible=1 and datum >= now()')

	belongs_to :user , :foreign_key => "owner"
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country, :foreign_key => "land"
	belongs_to :festival, :foreign_key => "festival"
	#belongs_to :regional_organization, foreign_key => "lv"
	self.table_name = 'konzerte'

  def zeit_formatted 
     zeit.strftime '%H:%M Uhr'
  end

  def datum_formatted=(value)
   self.datum = Time.parse(value)
  end

  def self.search(search)
	if (search)
		where('concerts.titel like ? or concerts.ort like ?',"#{search}","#{search}")
	else
		scoped
	end
  end
  def self.searchByDate(search)
	if (search)
		where('concerts.date = ? ',"#{search}")
	else
		scoped
	end
  end


  def self.inactive()
	where('visible=0')
  end
  def self.active()
	where('visible=1')
  end

  
end
