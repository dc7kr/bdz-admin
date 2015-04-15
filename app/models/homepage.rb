class Homepage < ActiveRecord::Base
  attr_accessible :abbrev, :created, :descr, :kontakt, :lastchange, :mitglnr, :name, :proben, :redir_url
end
