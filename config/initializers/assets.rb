%w( festival_applications ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js.coffee", "#{controller}.css"]
end

Rails.application.config.assets.precompile += %w( public.js public.css )
