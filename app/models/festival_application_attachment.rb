class FestivalApplicationAttachment < ApplicationRecord
  # attr_accessible :name
  has_one_attached :attached_file

  belongs_to :festival_application
end
