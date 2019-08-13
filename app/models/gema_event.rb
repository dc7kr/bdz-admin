class GemaEvent < ApplicationRecord
  include Authority::Abilities
  validates :nf_id, :uniqueness => true
end
