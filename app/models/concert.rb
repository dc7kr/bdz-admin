class Concert < ActiveRecord::Base
	belongs_to :user , :foreign_key => "fk_owner"
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country, :foreign_key => "land"
	belongs_to :festival, :foreign_key => "festival"
	#belongs_to :regional_organization, foreign_key => "lv"
	set_table_name "konzerte"

  def zeit_formatted 
     zeit.strftime '%H:%M Uhr'
  end

  def datum_formatted=(value)
   self.datum = Time.parse(value)
  end

end
