class DistinctionPolicy < MemberDataPolicy
  attr_reader :user, :distinction

  def initialize(user, distinction)
    @user = user
    @distinction = distinction
  end

  def invoice_preview?
    accounting_permission? or user.has_role? :distinction
  end

  def gen_invoice?
    accounting_permission? or user.has_role? :distinction
  end

  def destroy?
    distinction.member_account_booking == nil or user.has_role? :admin 
  end

  def edit?
    user.has_role? :admin or (distinction.member_account_booking == nil and (user.has_role? :national or user.has_role? :distinction))
  end

end
