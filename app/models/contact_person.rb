class ContactPerson < ApplicationRecord
  belongs_to :festival_application
  include CountryHelper

  def self.nested_params
    %i[salutation first_name last_name street zip city country_code email phone]
  end

  validates :last_name, :first_name, :email, :phone, presence: true
  validates :email, email_format: true

  has_many :contact_events

  def to_s
    "#{first_name} #{last_name}"
  end

  def fullname
    result = ""
    result = "#{result}#{first_name} " if first_name
    result += last_name if last_name
    result
  end

  def t_country(locale = "de")
    translated_country(country_code, locale)
  end

  def has_email?
    !email.nil?
  end

  def event_class
    ContactEvent
  end

  def to_addressee
    addressee = Addressee.new
    addressee.email        = email
    addressee.street       = street
    addressee.zip          = zip
    addressee.city         = city
    addressee.country_code = country_code
    addressee.id           = id
    addressee.email        = email
    addressee.event_entity_id = id
    addressee.event_class = event_class
    addressee.entity = self

    addressee
  end
end
