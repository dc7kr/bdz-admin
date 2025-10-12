class FestivalConcert < ApplicationRecord
  # attr_accessible :event_time, :location, :number, :title, :outdoor

  validates :event_time, presence: true

  scope :current_festival , -> { where("year(event_time) = ?", BDZ_SETTINGS["config"]["festival_year"]) }

  has_many :festival_applications

  def label
    "#{I18n.t('common.number')} #{number} #{title}"
  end
end
