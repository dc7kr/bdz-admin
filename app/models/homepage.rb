class Homepage < ApplicationRecord
  

  def member_exists?
    member = Member.where(mglnr: mitglnr)

    member.count.positive?
  end
end
