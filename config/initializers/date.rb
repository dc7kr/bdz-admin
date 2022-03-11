# File: config/initializers/date.rb
# Parse date using Rails I18n or Ruby parse method if it failed.
 
class Date
  class << self
    def _parse_with_i18n(str, format = :default)
      format ||= :default
      date = Date._strptime(str, I18n.translate("date.formats.#{format}")) || _parse_without_i18n(str)
      date[:year] += increment_year(date[:year].to_i) if date[:year]
      date
    end
 
    #alias_method :_parse, :i18n
 
    def increment_year(year)
      if year < 100
        year < 30 ? 2000 : 1900
      else
        0
      end
    end
  end
end
