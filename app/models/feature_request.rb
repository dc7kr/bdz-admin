class FeatureRequest < ActiveRecord::Base
  attr_accessible :description, :priority, :title,:status
end
