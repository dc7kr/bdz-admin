class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :delete, FestivalPiece
      can :update, FestivalApplication
    else
      can :read, Concert
      can :read, Course
      can :read, Contest
      can :read, State
      can :update, Concert, owner: user.id
      can :delete, Concert, owner: user.id
      can :manage, FeatureRequest

      if user.has_role?(:admin) || user.has_role?(:national)
        can :manage, :all
      else
        if user.address?
          can :read, RegionalOrganization
          can :read, PersonMember
          can :read, Orchestra
        end

        can :read, MemberAccountBooking if user.accounting?

        if user.honor?
          can :manage, Distinction
          can :manage, HonorMember
          can :read, MemberAccountBooking
          can :download, MemberAccountBooking
          can :read, RegionalOrganization
          can :read, PersonMember
          can :read, Orchestra
          can :read, OrchestraMember
        end

        if user.has_role?(:regional, :any)
          lv = RegionalOrganization.with_role(:regional, user).first
          lv_restriction = { regional_organization_id: lv.id }
          can :read, lv
          can %i[read lorch nopayment], Orchestra, member: lv_restriction
          can %i[read nopayment], PersonMember, member: lv_restriction
          can [ :read ], RegionalOrganization, id: lv.id
          can :read, RegionalOrganizationBooking, regional_organization: lv
          can %i[read search], OrchestraMember
          can %i[read download], MemberAccountBooking, member: lv_restriction
          can :read, Distinction
          can %i[read download], MemberEvent, member: lv_restriction
          can :read, OrchestraContact
        end
      end
    end
  end
end
