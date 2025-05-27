class Concert < ApplicationRecord
  include Authority::Abilities
  self.authorizer = PublicEntityAuthorizer

  validates :eintritt, presence: true
  validates :ort, :stadt, :concert_date, presence: true

  validates :uid, uniqueness: true

  def self.future
    where(concert_date: Time.zone.now..).order(:concert_date)
  end

  scope :published, -> { where("visible=1 and concert_date >= ?", Time.zone.now).order(:concert_date) }
  scope :inactive, -> { where("visible=0") }
  # scope :future, -> { where('concert_date >= ?', Time.now) }

  belongs_to :user, foreign_key: "owner"
  belongs_to :state, foreign_key: "bland"
  belongs_to :festival
  # belongs_to :regional_organization, foreign_key => "lv"

  def zeit_formatted
    zeit.strftime "%H:%M Uhr"
  end

  def datum_formatted=(value)
    self.datum = Time.zone.parse(value)
  end

  def self.search(search)
    if search
      where("concerts.titel like ? or concerts.ort like ?", search.to_s, search.to_s)
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

  def self.active
    where("visible=1")
  end
end
