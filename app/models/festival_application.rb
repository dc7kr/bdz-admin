class FestivalApplication < ActiveRecord::Base
  attr_accessible :conductor, :contact_person, :equipment, :country_code, :num_players, :orch_name, :orchestra, :special_cast, :group_type,:permission,:festival_concert_id, :visitor_type, :rehearsal_time
  has_many :festival_pieces
  has_many :festival_application_attachments

  accepts_nested_attributes_for :festival_pieces, :allow_destroy => :true


  belongs_to :contact_person
  belongs_to :orchestra
  belongs_to :festival_concert



end
