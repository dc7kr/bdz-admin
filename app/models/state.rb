class State < ActiveRecord::Base
  belongs_to :country, :foreign_key => "land"
  self.table_name = 'bundeslaender'
end
