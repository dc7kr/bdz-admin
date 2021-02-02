class PopulateBicMembers < ActiveRecord::Migration[4.2]
  def up

    bic_finder = BicFinder.new

    Member.all.each do |m|
      m.update_attribute :bic , bic_finder.bic_for_blz(m.blz)
    end
    
  end

  def down
  end
end
