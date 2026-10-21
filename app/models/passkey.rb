class Passkey < ApplicationRecord
  # a User (staff) or a Member (member area)
  belongs_to :owner, polymorphic: true

  validates :label, presence: true, uniqueness: { scope: %i[owner_type owner_id] }
  validates :external_id, :public_key, presence: true
end
