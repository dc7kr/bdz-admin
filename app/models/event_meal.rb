class EventMeal < ActiveRecord::Base
  # attr_accessible :title, :body

  validates_presence_of  :participant_id, :tln, :veg, :email, :name, :arrival_time
  validates :email, :email_format => true 

  validates :tln, :meal => true
  validates :veg, :meal => true

  self.table_name = 'event_food'
end
