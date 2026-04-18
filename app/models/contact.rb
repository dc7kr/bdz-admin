class Contact < ApplicationRecord
  include CountryHelper

  def self.nested_attributes
    %i[id company first_name last_name street zip city country_code salutation phone fax office_phone email title department mobile]
  end

  belongs_to :contact_entity, polymorphic: true

  def to_s
    "#{first_name} #{last_name}"
  end

  def fullname
    result = ""
    result = "#{result}#{first_name} " if first_name
    result += last_name if last_name
    result
  end

  def t_country(locale = country_code)
    translated_country(country_code, locale)
  end

  def letter_country
    return "" if country_code.nil?

    country_code.upcase
  end

  def to_customer
    c = CorikaInvoices::Customer.new
    c.salutation = salutation
    c.first_name = vorname
    c.last_name = name
    c.entity = self
    c.street = strasse
    c.zip = plz
    c.city = ort
    c.email = email
    c.country = country_code

    c
  end

  def one_line_addr
    components = []
    components << company if company.present?
    components << fullname if fullname.present?
    components << street
    components << ("#{zip} #{city}")

    components.join(", ")
  end
end
