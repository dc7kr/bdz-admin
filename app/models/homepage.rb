class Homepage < ActiveRecord::Base
  include Authority::Abilities
end
