class FestivalExhibitor < ApplicationRecord
  scope :current_festival, -> { where(year: BDZ_SETTINGS["config"]["festival_year"]) }

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact
end
