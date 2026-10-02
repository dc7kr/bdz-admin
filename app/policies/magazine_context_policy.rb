class MagazineContextPolicy < ApplicationPolicy
  allow :show?, :create?, :update?, to: :national
end
