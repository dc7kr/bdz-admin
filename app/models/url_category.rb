class UrlCategory < ApplicationRecord
  

  belongs_to :parent, class_name: "UrlCategory"
end
