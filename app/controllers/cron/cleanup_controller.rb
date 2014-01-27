class Cron::CleanupController < AuthenticatedNonResourceController

  def remove_resigned
  	authorize! :member, :edit
    @orchestras = Orchestra.cancelled
    @person_members = PersonMember.cancelled

    @resigned_orchestras = Array.new
    @resigned_persons = Array.new

    @orchestras.each do |o|
      @resigned_orchestras << { :mglnr => o.mglnr, :name => o.orchName , :resigned => o.austritt_zum}
      o.member.destroy 
      o.destroy 
    end

    @person_members.each do |p|
      @resigned_persons << { :mglnr => p.mglnr, :name=>p.fullname, :resigned=> p.austritt_zum }
      p.member.destroy
      p.destroy
    end
  end
end
