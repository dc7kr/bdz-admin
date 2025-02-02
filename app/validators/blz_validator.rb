require 'ktoblzcheck'

class BlzValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, ": #{options[:message] || I18n.t('errors.blz.required_by_za')}") if record.za == 'L'
      return
    end

    r = false
    KtoBlzCheck.new('/var/lib/ktoblzcheck1/bankdata.txt') do |kbc|
      name, = kbc.find(record.blz)
      r = if name
            true
          else
            false
          end
    end

    #    r = blz >= 10000000 and blz <= 99999999
    record.errors.add(attribute, (options[:message] || I18n.t('errors.blz.unknown'))) unless r
  end
end
