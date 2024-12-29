class CleanupJob < ApplicationJob

  include BulkMailHelper

  # sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def default_url_options
    {
      :host =>  ActionMailer::Base.default_url_options[:host],
      :protocol => ActionMailer::Base.default_url_options[:protocol]
    }
  end


  def perform()
    orchestras = Orchestra.cancelled
    person_members = PersonMember.cancelled

    resigned_orchestras = Array.new
    resigned_persons = Array.new

    orchestras.each do |o|
      resigned_orchestras << { :mglnr => o.member.mglnr, :name => o.orchName , :resigned => o.member.austritt_zum}
      o.member.destroy 
      o.destroy 
      Rails.logger.debug("Resigned: #{o.member.mglnr}")
    end

    person_members.each do |p|
      resigned_persons << { :mglnr => p.member.mglnr, :name=>p.fullname, :resigned=> p.member.austritt_zum }
      p.member.destroy
      p.destroy
      Rails.logger.debug("Resigned: #{p.member.mglnr}")
    end

    if resigned_persons.length() > 0 or resigned_orchestras.length() > 0
      send_mail(resigned_persons, resigned_orchestras)
    end
  end

  def send_mail(resigned_persons,resigned_orchestras)
    User.for_admin_notify.each do |user|
      AdminNotifier.cleanup_notification(user, resigned_persons, resigned_orchestras).deliver
    end
  end
end
