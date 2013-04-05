class MagazineAdvert < ActiveRecord::Base

  belongs_to :advertiser
  belongs_to :magazine_issue
end
