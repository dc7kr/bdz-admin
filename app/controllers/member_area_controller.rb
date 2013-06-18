class MemberAreaController < ApplicationController

  def index 

  end

  def show
    @p = params
    member = Member.find_by_mglnr(params[:id])
    if member.subtype == "PersonMember" then 
      @person_member = PersonMember.find_by_member_id(member.id)
    elsif member.subtype  == "Orchestra"
      @orchestra = Orchestra.find_by_member_id(member.id)
    end
  end

end
