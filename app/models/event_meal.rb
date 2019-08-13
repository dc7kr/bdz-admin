class EventMeal < ApplicationRecord
  # attr_accessible :title, :body
  belongs_to :festival_application, :foreign_key => "participant_id"

  validates_presence_of  :participant_id, :tln, :veg, :email, :name, :arrival_time
  validates :email, :email_format => true 

  validates :arrival_time, :datetime => true
  validates :tln, :meal => true
  validates :veg, :meal => true

  self.table_name = 'event_food'
end
