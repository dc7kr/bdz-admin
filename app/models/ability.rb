class Ability
  include CanCan::Ability

  def initialize(user)
    if user != nil
      can :read, Concert
      can :read, Course
      can :read, Contest
      can :read, State
      can :update, Concert, :owner => user.id
      can :delete, Concert, :owner => user.id
      can :manage, FeatureRequest


      if ( user.has_role?(:admin) or user.has_role?(:national)) 
        can :manage, :all
      else
        if ( user.address? )
            can :read, RegionalOrganization
            can :read, PersonMember
            can :read, Orchestra
        end

        if ( user.accounting? ) 
          can :read, MemberAccountBooking
        end

        if ( user.honor? )
          can :manage, Distinction 
          can :read, MemberAccountBooking
          can :download, MemberAccountBooking
          can :read, RegionalOrganization
          can :read, PersonMember
          can :read, Orchestra
          can :read, OrchestraMember
        end

        if ( user.has_role?(:regional)) then
          lv = RegionalOrganization.with_role(:regional, user)
          lv_restriction = { :regional_organization_id => lv.first.id }
          can :read, lv.first
          can [:read,:lorch], Orchestra, :member => lv_restriction 
          can :read, PersonMember, :member => lv_restriction
          can [:read], RegionalOrganization, :id => lv.first.id
          can :read, RegionalOrganizationBooking, :regional_organization => lv.first
          can [:read,:search], OrchestraMember
          can [:read,:download], MemberAccountBooking, :member => lv_restriction
          can :read, Distinction
          can [:read,:download], MemberEvent, :member => lv_restriction
          can :read, OrchestraContact
        end
      end
    end
  end
end
