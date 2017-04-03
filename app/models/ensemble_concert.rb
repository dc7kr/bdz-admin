class EnsembleConcert < ActiveRecord::Base
	belongs_to :festival
	belongs_to :ensemble
	belongs_to :bundesland

	scope :inactive, where("visible = 0")


  scope :published, -> { where('visible=1 and datum>= ?',Time.now) }
  scope :inactive, -> { where('visible=0') }

  def self.search(search)
    if (search)
      where('ensemble_concerts.titel like ? or ensemble_concerts.ort like ?',"#{search}","#{search}")
    else
      where(1)
    end
  end
end

