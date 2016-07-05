class MemberAreaController < ApplicationController

  def index 

  end

  def show
    @p = params
    member = Member.find_by_mglnr(params[:id])
    if member.member_entity_type == "PersonMember" then 
      @person_member = member.member_entity
    elsif member.member_entity_type  == "Orchestra"
      @orchestra = member.member_entity
    end
  end

end
