class FestivalConcert < ApplicationRecord
  #attr_accessible :event_time, :location, :number, :title, :outdoor

  validates_presence_of :event_time

  has_many :festival_applications

  def label
    return I18n.t("common.number")+" "+number.to_s+" "+title
  end
end
