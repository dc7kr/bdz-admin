class FestivalConcert < ApplicationRecord
  # attr_accessible :event_time, :location, :number, :title, :outdoor

  validates :event_time, presence: true

  scope :current_festival, -> { where("year(event_time) = ?", BDZ_SETTINGS["config"]["festival_year"]) }
  scope :current_outdoor, -> { where("year(event_time) = ? and outdoor=1", BDZ_SETTINGS["config"]["festival_year"]) }

  has_many :festival_applications, class_name: "FestivalApplication", foreign_key: "festival_concert_id"
  has_many :outdoor_participants, class_name: "FestivalApplication", foreign_key: "outdoor_concert_id"

  def label
    "#{I18n.t('common.number')} #{number} #{title}"
  end

  def full_title
    if title.present?
      "#{concert_id} - #{title}"
    else
      "#{concert_id}"
    end
  end
end
