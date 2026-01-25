class FestivalPiece < ApplicationRecord
  # attr_accessible :composer, :duration, :festival_application, :title

  belongs_to :festival_application

  scope :current_festival, -> { joins(:festival_application).where("festival_applications.year = ?", BDZ_SETTINGS["config"]["festival_year"]) }

  validates_presence_of :title, :composer, :duration, :publisher

  def printable_duration
      duration.strftime("%H:%M")
  end
end
