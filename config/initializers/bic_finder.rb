Rails.application.config.to_prepare do
  BIC_FINDER = BicFinder.new
end
