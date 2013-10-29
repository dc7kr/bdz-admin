class FestivalConcert < ActiveRecord::Base
  attr_accessible :event_time, :location, :number, :title, :outdoor

  has_many :festival_applications

  def label
    return number.to_s+" "+title
  end
end
