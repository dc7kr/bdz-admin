class Classified < ApplicationRecord
  include Authority::Abilities

  validates :object, :description, :name, presence: true
  validates :email, presence: true, email_format: true

  scope :inactive, -> { where('visible=0') }
  scope :not_expired, -> { where('validuntil >= now()') }
  scope :active, -> { where('visible=1') }

  def self.search(search)
    if search
      where('title = ?', "#{search}")
    else
      where(1)
    end
  end
end
