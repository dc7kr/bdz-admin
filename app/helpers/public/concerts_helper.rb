module Public
  module ConcertsHelper
    def magazine_time_format(date)
      if date.hour.zero? && date.min.zero?
        ""
      else
        "#{date.strftime('%H.%M')} Uhr, "
      end
    end
  end
end
