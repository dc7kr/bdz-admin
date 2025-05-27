class BoardContact < ApplicationRecord
  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact

  def fullname
    if contact.nil?
      "INCONSISTENT!"
    else
      contact.fullname
    end
  end

  delegate :to_s, to: :contact

  def self.search(search)
    if search
      where("last_name like ? or first_name like ?", "%#{search}%", "%#{search}%")
    else
      where(1)
    end
  end
end
