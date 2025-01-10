class PublicEntityAuthorizer < ApplicationAuthorizer
  # anyone can create a public entity
  def self.creatable_by?(_user)
    true
  end

  def self.readable_by?(_user)
    true
  end

  def self.editable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end

  def self.updatable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end

  def self.deletable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end

  def deletable_by?(user)
    user.has_role? :admin
  end

  def editable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end

  def updatable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end
end
