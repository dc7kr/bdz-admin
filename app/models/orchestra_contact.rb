class OrchestraContact < ApplicationRecord
  belongs_to :orchestra

  validates :email, email_format: true

  def self.permitted_params
    %i[role salutation first_name last_name street zip city country_code email phone]
  end

  def self.roles
    %w[V S G D J O R Z]
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def to_s
    data = ["#{first_name} #{last_name}", street, "#{zip} #{city}", phone, email]
    data.join("\n")
  end
end
