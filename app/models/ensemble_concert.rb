class EnsembleConcert < ActiveRecord::Base
    self.table_name = 'konz_ensemble'
	belongs_to :ensemble


end

