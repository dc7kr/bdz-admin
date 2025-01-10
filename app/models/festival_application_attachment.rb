class FestivalApplicationAttachment < ApplicationRecord
  # attr_accessible :name
  has_attached_file :attached_file

  belongs_to :festival_application
end
