class UrlCategory < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :parent, class_name: "UrlCategory", foreign_key: "parent_id"
  
end
