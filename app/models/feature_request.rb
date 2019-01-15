class FeatureRequest < ApplicationRecord
  #attr_accessible :description, :priority, :title,:status,:user_id

  belongs_to :user

  def owner_s
    if user then
      user.email
    else
      I18n.t("common.no_one")
    end
  end
end
