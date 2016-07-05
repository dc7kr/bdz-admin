class EnsembleConcert < ActiveRecord::Base
	belongs_to :festival
	belongs_to :ensemble
	belongs_to :bundesland

	scope :published, where("visible =1 and datum >= now()")
	scope :inactive, where("visible = 0")


end

