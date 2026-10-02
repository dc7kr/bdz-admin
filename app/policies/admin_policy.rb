# frozen_string_literal: true

# headless policy for the admin pages: authorize :admin, :show?
class AdminPolicy < ApplicationPolicy
  allow :index?, :show?, to: :admin
end
