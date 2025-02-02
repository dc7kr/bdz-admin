class FestivalConcert < ApplicationRecord
  # attr_accessible :event_time, :location, :number, :title, :outdoor

  validates :event_time, presence: true

  has_many :festival_applications

  def label
    "#{I18n.t('common.number')} #{number} #{title}"
  end
end
