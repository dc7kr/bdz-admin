class Passkey < ApplicationRecord
  belongs_to :user

  validates :label, presence: true, uniqueness: { scope: :user_id }
  validates :external_id, :public_key, presence: true
end
