require 'icalendar'
require 'date'
require 'open-uri'


class CalendarSyncController < AuthenticatedNonResourceController
	@@bw_url="https://www.google.com/calendar/ical/redaktion%40zupfer-kurier.de/public/basic.ics"

	include Icalendar # Probably do this in your class to limit namespace overlap
#	rescue_from do |exception|  
#				@err << exception
#	end

	def update_from_event(conc,event,is_new)
		if (is_new or conc.updated_at == nil or event.last_modified > conc.updated_at) then
				summ = event.summary.split(":")
				if (summ[1]==nil ) then 
					conc.titel=summ[0]
				else
					conc.titel = summ[1]
				end
				conc.interpret = summ[0]
				conc.datum = event.dtstart
				conc.zeit = event.dtstart.strftime("%H:%M")
				loc = event.location.split(",")
				conc.ort = loc[0]
				conc.stadt = loc[1]
				conc.reported = Time.now
				conc.comment =""
				conc.url=""
				conc.confirmed=1
				conc.country_id=81
				conc.eintritt=0
				conc.token=conc.uid
			true
		else 
			false
		end
	end

	def upload

		cal_file = open(@@bw_url)

		cals = Icalendar.parse(cal_file)
		cal = cals.first

		@imported = Array.new
		@existing = Array.new
		@err = Array.new
		@faulty = Array.new
		# Now you can access the cal object in just the same way I created it
		cal.events.each do |event|
			future=false
			new =false

			if ( event.dtstart < Time.now.to_date ) then
				Rails.logger.info("Ignored event in the past: "+event.dtstart.strftime("%d.%m.%Y %H:%M"))
				next
			end

			conc = Concert.find_by_uid(event.uid)
			if ( conc == nil ) then
				conc = Concert.new
				conc.uid = event.uid
				@imported << conc
				new=true
			end

			if update_from_event(conc,event,new) then 
				begin
					conc.save
					if (!new) then
						@existing << conc
					end
				rescue 	Exception => e
					@err << e
					@faulty << event
					Rails.logger.error e.class
				end
			end
		end
	end
end
