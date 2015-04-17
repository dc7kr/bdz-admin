require 'icalendar'
require 'date'
require 'open-uri'


class CalendarSyncController < AuthenticatedNonResourceController
	@@bw_url="https://www.google.com/calendar/ical/redaktion%40zupfer-kurier.de/public/basic.ics"

	#include Icalendar # Probably do this in your class to limit namespace overlap
#	rescue_from do |exception|  
#				@err << exception
#	end

	def update_from_event(conc,event,is_new)
		if (conc.id.nil? or conc.updated_at.nil? or event.last_modified > conc.updated_at) then
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

        if loc[1].nil? then
          conc.stadt =""
        else
				  conc.stadt = loc[1]
        end
				conc.reported = Time.now
				conc.comment =""
				conc.url=""
				conc.confirmed=1
				conc.country_code="de"
				conc.eintritt=0
				conc.token=event.uid.to_s
			true
		else 
			false
		end
	end

	def upload

    authorize! :member, :edit
		cal_file = open(@@bw_url)

		cals = Icalendar.parse(cal_file)
		cal = cals.first

    owner = current_user

    if owner.nil? then
      owner = User.find(1)
    end


    Rails.logger.debug("Owner: #{owner}")

		@imported = Array.new
		@existing = Array.new
		@err = Array.new
		@faulty = Array.new

		cal.events.each do |event|
			future=false
			new =false

			if ( event.dtstart < Time.now.to_date ) then
				# Rails.logger.info("Ignored event in the past: "+event.dtstart.strftime("%d.%m.%Y %H:%M"))
				next
			end

      uid = event.uid.to_s
      Rails.logger.debug("Event: #{uid}")

			conc = Concert.find_by_uid(uid)
			if ( conc.nil? ) then
				conc = Concert.new
				conc.uid = event.uid.to_s
        conc.user=owner
				@imported << conc
				new=true
      elsif conc.user.nil? then
        Rails.logger.info("Owner was nil, setting to current user #{conc.uid}")
        conc.user = owner
			end


			if update_from_event(conc,event,new) then 
        logger.debug "Concert: #{conc.inspect}"
				#begin
          logger.debug "Datum: #{conc.datum}"
          logger.debug "Zeit: #{conc.zeit}"
					conc.save

          if (conc.errors.any?) then
            log_record_errors(conc)
            @faulty << conc
          elsif (!new) then
						@existing << conc
					end
				#rescue 	Exception => e
			#		@err << e
		#			@faulty << [ event, e ]
	#				logger.error "#{e.class} #{e.message}"
  #        logger.error e.backtrace.join("\n")   
#				end
      else 
        Rails.logger.info("Event: #{event.uid} - not updated (no change?)")
			end
		end
	end
end
