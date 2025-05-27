class EnsembleConcert < ApplicationRecord
  belongs_to :festival
  belongs_to :ensemble
  belongs_to :bundesland

  scope :inactive, -> {  where("visible = 0") }

  scope :published, -> { where("visible=1 and datum>= ?", Time.zone.now) }
  scope :inactive, -> { where("visible=0") }

  def self.search(search)
    if search
      where("ensemble_concerts.titel like ? or ensemble_concerts.ort like ?", search.to_s, search.to_s)
    else
      where(1)
    end
  end
end
