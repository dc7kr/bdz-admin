class BoardContact < ActiveRecord::Base
  inherits_from :contact

  def fullname
    contact.fullname
  end

  def to_s
    contact.to_s
  end

  def id
    contact.id
  end

end
