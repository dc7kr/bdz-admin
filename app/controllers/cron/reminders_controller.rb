require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
class Cron::RemindersController < ApplicationController
  load_and_authorize_resource

 def index


    @accounts = MemberAccountBooking.sum(:amount,:group=>:member_id)

    @ids = Set.new
    @accounts.each do |account|
      if (account[1]<0) then
        @ids.add(account[0])
      end
    end

    @persons = PersonMember.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])
	@orchestras = Orchestra.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])

	@tw = TexWriter.new 
	@orchestras.each do |orch|
		@tw.writeReminderData(orch)
		system("/opt/bdz-rechnung/bin/mahnung.sh "+String(orch.mglnr))
	end

	@persons.each do |person|
		@tw.writeReminderData(person)
		system("/opt/bdz-rechnung/bin/mahnung.sh "+String(person.mglnr))
	end

	system("/opt/bdz-rechnung/bin/merge_pdfs.sh mahnung")


	render :text => " OK."
  end
end
