class FestivalApplication < ActiveRecord::Base
  attr_accessible :conductor, :contact_person, :equipment, :country_id, :num_players, :orch_name, :orchestra, :special_cast, :group_type,:permission
  has_many :festival_pieces

  accepts_nested_attributes_for :festival_pieces, :allow_destroy => :true


  belongs_to :contact_person
  belongs_to :country
  belongs_to :orchestra

end
