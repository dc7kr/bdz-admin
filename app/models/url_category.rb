class UrlCategory < ActiveRecord::Base

  belongs_to :parent, class_name: "UrlCategory", foreign_key: "parent_id"
  
end
