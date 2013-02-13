class FestivalApplication < ActiveRecord::Base
  attr_accessible :conductor, :contact_person, :equipment, :nationality, :num_players, :orch_name, :orchestra, :special_cast

  belongs_to :contact_person
  belongs_to :nationality, :class_name => "Country", :foreign_key => "nationality"
  belongs_to :orchestra
end
