class Composer < ActiveRecord::Base
  belongs_to :composer, :foreign_key => "fk_ref_comp"
  self.table_name = "komponisten"
end
