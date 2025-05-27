module Reports
  class NewMembersController < AuthenticatedNonResourceController
    def index
      authorize! :member, :edit
      @orchestras = Orchestra.includes(:member).where(" members.eintritt > ?",
                                                      Time.zone.today - 6.months).order("members.mglnr")
      @persons = PersonMember.includes(:member).where(" members.eintritt > ?",
                                                      Time.zone.today - 6.months).order("members.name, members.vorname")
    end
  end
end
