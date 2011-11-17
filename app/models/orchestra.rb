class Orchestra < ActiveRecord::Base
  belongs_to :regional_organization
  has_many :report_sheet

end
