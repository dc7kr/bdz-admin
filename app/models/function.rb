class Function < ActiveRecord::Base
	belongs_to :regional_organization, :foreign_key => "fk_lv_id"
	belongs_to :address, :foreign_key => "fk_addr_id"
end
