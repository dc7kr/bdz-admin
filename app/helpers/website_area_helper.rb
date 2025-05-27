module WebsiteAreaHelper
  def current_area
    @website_area || "public_data"
  end
end
