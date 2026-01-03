class Url < ApplicationRecord
  
  belongs_to :url_category, foreign_key: "category"
  belongs_to :state, foreign_key: "bland"

  scope :published, -> { where("visible=1") }
  scope :inactive, -> { where("visible=0") }

  def self.search(search)
    if search
      where("url like ? or titel like ?", "%#{search}%", "%#{search}%")
    else
      where(1)
    end
  end
end
