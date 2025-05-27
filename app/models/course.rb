class Course < ApplicationRecord
  belongs_to :user, foreign_key: "fk_owner"
  belongs_to :state, foreign_key: "bland"
  belongs_to :festival, foreign_key: "festival"

  scope :future, -> { where("startdate>= now()") }
  scope :inactive, -> { where("visible=0") }
  scope :active, -> { where("visible=1") }
  scope :published, -> { where("visible=1 and startdate >= now()") }

  # belongs_to :regional_organization, foreign_key => "lv"

  def zeit_formatted
    zeit.strftime "%H:%M Uhr"
  end

  def datum_formatted=(value)
    self.datum = Time.zone.parse(value)
  end

  def self.search(search)
    if search
      where("titel like ? or ort like ?", search.to_s, search.to_s)
    else
      where(1)
    end
  end

  def self.searchByDate(search)
    if search
      where("concerts.date = ? ", search.to_s)
    else
      where(1)
    end
  end
end
