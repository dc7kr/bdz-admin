class Public::OrchestrasController  < ApplicationController

  def index
    @regional_organization = RegionalOrganization.find(params[:lv_id])
    @alpha_links = Hash.new
    @members = @regional_organization.members.where("member_entity_type='Orchestra'").sort_by{ |member| member.member_entity.orchName.upcase }
 
    firstLetter =""
 
    @members.each do |m|
      f = m.member_entity.orchName[0].upcase
      if (firstLetter != f) 
        @alpha_links[m.id] = f
        firstLetter = f
      end
    end

  end
end
