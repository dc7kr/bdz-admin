class FestivalPiece < ActiveRecord::Base
  attr_accessible :composer, :duration, :festival_application, :title

  belongs_to :festival_application
end
