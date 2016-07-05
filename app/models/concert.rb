class Concert < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer = PublicEntityAuthorizer

  validates_presence_of :eintritt

  def self.future 
    where('concert_date >= ?', Time.now).order(:concert_date)
  end

  scope :published, -> { where('visible=1 and concert_date >= ?',Time.now) }
	scope :inactive, -> { where('visible=0') }
  #scope :future, -> { where('concert_date >= ?', Time.now) }

	belongs_to :user , :foreign_key => "owner"
	belongs_to :state, :foreign_key => "bland"
	belongs_to :festival
	#belongs_to :regional_organization, foreign_key => "lv"

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
		where(1)
	end
  end
  def self.searchByDate(search)
	if (search)
		where('concerts.date = ? ',"#{search}")
	else
		where(1)
	end
  end


  def self.active()
	where('visible=1')
  end

  
end
