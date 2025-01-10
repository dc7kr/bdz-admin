class Composer < ApplicationRecord
  belongs_to :composer, foreign_key: 'fk_ref_comp'
end
