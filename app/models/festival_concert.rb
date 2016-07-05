class FestivalConcert < ActiveRecord::Base
  #attr_accessible :event_time, :location, :number, :title, :outdoor

  has_many :festival_applications

  def label
    return I18n.t("common.number")+" "+number.to_s+" "+title
  end
end
