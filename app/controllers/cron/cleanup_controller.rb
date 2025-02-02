module Cron
  class CleanupController < AuthenticatedNonResourceController
    def remove_resigned
      authorize! :member, :edit
      @orchestras = Orchestra.cancelled
      @person_members = PersonMember.cancelled

      @resigned_orchestras = []
      @resigned_persons = []

      @orchestras.each do |o|
        @resigned_orchestras << { mglnr: o.member.mglnr, name: o.orchName, resigned: o.member.austritt_zum }
        o.member.destroy
        o.destroy
      end

      @person_members.each do |p|
        @resigned_persons << { mglnr: p.member.mglnr, name: p.fullname, resigned: p.member.austritt_zum }
        p.member.destroy
        p.destroy
      end
    end
  end
end
