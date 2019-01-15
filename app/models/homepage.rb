class Homepage < ApplicationRecord
  include Authority::Abilities

  def member_exists?
    member = Member.where(:mglnr => self.mitglnr)

    return member.count > 0
  end
end
