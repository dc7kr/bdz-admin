# Default rules for public data, see docs/permissions.md#public-data
class PublicDataPolicy < ApplicationPolicy
  # anyone can view and create a public entity
  def show? = true
  def create? = true

  allow :update?, :destroy?, to: %i[national public_data]
end
