class State < ActiveRecord::Base
  belongs_to :country
  set_table_name "bundeslaender"
end
