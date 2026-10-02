class HomepagePolicy < PublicDataPolicy
  allow :update?, :destroy?, to: :admin
end
