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

  def to_hash
    result = Hash.new
    result["location"] = location
    result["id"] = concert_id
    result["title"] = title
    result["datetime"] = I18n.l event_time
    result["id"] = title[0..2]
    result["participants"] = Array.new


    if outdoor
      outdoor_participants.each do |fp|
        result["participants"] << fp.to_hash
      end
    else
      festival_applications.each do |fp|
        result["participants"] << fp.to_hash
      end
    end

    result
  end

end
