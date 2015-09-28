require 'test_helper'

class UrlCategoryTest < ActiveSupport::TestCase
  test "strong parameters" do
    params= { :person => {:id=>42 }} 
    UrlCategory.create(params[:person])
    assert true
  end
  
end
