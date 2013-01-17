class EnsembleConcert < ActiveRecord::Base
    self.table_name = 'konz_ensemble'
	belongs_to :festival
	belongs_to :ensemble
	belongs_to :land
	belongs_to :bundesland

	scope :public, where("visible =1 and datum >= now()")
	scope :inactive, where("visible = 0")


end

