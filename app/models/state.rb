class State < ActiveRecord::Base
  belongs_to :country, :foreign_key => "land"
  set_table_name "bundeslaender"
end
