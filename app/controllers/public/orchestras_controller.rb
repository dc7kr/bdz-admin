module Public
  class OrchestrasController < Public::ApplicationController
    def index
      @regional_organization = RegionalOrganization.find(params[:lv_id])
      @alpha_links = {}
      @members = @regional_organization.members.where("member_entity_type='Orchestra'").sort_by do |member|
        member.member_entity.orchName.upcase
      end

      firstLetter = ''

      @members.each do |m|
        next unless m.member_entity.publish_url

        f = m.member_entity.orchName[0].upcase

        if firstLetter != f
          @alpha_links[m.id] = f
          firstLetter = f
        end
      end
    end
  end
end
