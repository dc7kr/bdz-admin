class Festival < ApplicationRecord
  include Authority::Abilities
  belongs_to :state, foreign_key: "bland"

  scope :published, -> { where("visible=1 and startdate >= now()") }

  def self.search(search)
    if search
      where("titel like ?", "%#{search}%")
    else
      where(1)
    end
  end
end
