module Public::ConcertsHelper
  def magazine_time_format(date)
    if date.hour == 0 and date.min == 0
      ''
    else
      "#{date.strftime('%H.%M')} Uhr, "
    end
  end
end
