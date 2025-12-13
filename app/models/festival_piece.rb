class FestivalPiece < ApplicationRecord
  # attr_accessible :composer, :duration, :festival_application, :title

  belongs_to :festival_application

  validates_presence_of :title, :composer, :duration, :publisher
end
