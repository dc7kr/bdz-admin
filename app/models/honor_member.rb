class HonorMember < ApplicationRecord
  include ActiveModel::ForbiddenAttributesProtection

  def fullname
    full = ""
    full += "#{title} " unless title.nil? or title.empty?
    full += "#{vorname} " unless vorname.nil? or vorname.empty?
    full += name
  end
end
