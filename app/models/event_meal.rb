class EventMeal < ApplicationRecord
  # attr_accessible :title, :body
  belongs_to :festival_application, foreign_key: "participant_id"

  validates :participant_id, :tln, :veg, :email, :name, :arrival_time, presence: true
  validates :email, email_format: true

  validates :arrival_time, datetime: true
  validates :tln, meal: true
  validates :veg, meal: true

  scope :current_festival, -> { where("festival_year = ?", BDZ_SETTINGS["config"]["festival_year"]) }
end
