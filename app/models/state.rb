class State < ActiveRecord::Base
  belongs_to :country
  self.table_name = 'bundeslaender'
end
