class HonorMember < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
end
