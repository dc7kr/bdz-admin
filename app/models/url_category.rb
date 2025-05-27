class UrlCategory < ApplicationRecord
  include Authority::Abilities

  belongs_to :parent, class_name: "UrlCategory"
end
