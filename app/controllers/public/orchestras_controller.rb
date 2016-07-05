class Public::OrchestrasController  < ApplicationController

  def by_lv 
    @regional_organization = RegionalOrganization.find(params[:lv])

    @members = @regional_organization.members.where("member_entity_type='Orchestra'").sort_by{ |member| member.member_entity.orchName }

  end
end
