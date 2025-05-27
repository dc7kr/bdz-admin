require "icalendar"
require "date"
require "open-uri"

module Adm
  class CalendarSyncController < AuthenticatedNonResourceController
    @@bw_url = "https://www.google.com/calendar/ical/redaktion%40zupfer-kurier.de/public/basic.ics"

    # include Icalendar # Probably do this in your class to limit namespace overlap
    #	rescue_from do |exception|
    #				@err << exception
    #	end

    def update_from_event(conc, event, _is_new)
      if conc.id.nil? || conc.updated_at.nil? || (event.last_modified > conc.updated_at)
        summ = event.summary.split(":")
        conc.titel = if summ[1].nil?
                       summ[0]
        else
                       summ[1]
        end
        conc.interpret = summ[0]
        conc.datum = nil
        conc.concert_date = event.dtstart
        conc.zeit = nil
        loc = event.location.split(",")
        conc.ort = loc[0]

        conc.stadt = if loc[1].nil?
                       ""
        else
                       loc[1]
        end
        conc.reported = Time.zone.now
        conc.comment = ""
        conc.url = ""
        conc.confirmed = 1
        conc.bland = nil
        conc.country_code = "DE"
        conc.eintritt = 0
        conc.token = event.uid.to_s
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

      owner = User.find(1) if owner.nil?

      Rails.logger.debug { "Owner: #{owner}" }

      @imported = []
      @existing = []
      @err = []
      @faulty = []

      cal.events.each do |event|
        new = false

        if event.dtstart < Time.zone.now.to_date
          # Rails.logger.info("Ignored event in the past: "+event.dtstart.strftime("%d.%m.%Y %H:%M"))
          next
        end

        uid = event.uid.to_s
        Rails.logger.debug { "Event: #{uid}" }

        conc = Concert.find_by(uid: uid)
        if conc.nil?
          conc = Concert.new
          conc.uid = event.uid.to_s
          conc.user = owner
          @imported << conc
          new = true
        elsif conc.user.nil?
          Rails.logger.info("Owner was nil, setting to current user #{conc.uid}")
          conc.user = owner
        end

        if update_from_event(conc, event, new)
          logger.debug "Concert: #{conc.inspect}"
          # begin
          logger.debug "Datum: #{conc.datum}"
          logger.debug "Zeit: #{conc.zeit}"
          conc.save

          if conc.errors.any?
            log_record_errors(conc)
            @faulty << conc
          elsif !new
            @existing << conc
          end
        # rescue 	Exception => e
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
end
