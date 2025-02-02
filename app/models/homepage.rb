class Homepage < ApplicationRecord
  include Authority::Abilities

  def member_exists?
    member = Member.where(mglnr: mitglnr)

    member.count.positive?
  end
end
