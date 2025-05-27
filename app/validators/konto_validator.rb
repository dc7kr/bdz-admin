require "ktoblzcheck"

class KontoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value || value.zero?
      record.errors.add(attribute, (options[:message] || I18n.t("errors.konto.required_by_za"))) if record.za == "L"
      return
    end
    KtoBlzCheck.new do |kbc|
      name, = kbc.find(record.blz)
      if name
        name = name.force_encoding("ISO-8859-1").encode("UTF-8")
        case kbc.check(record.blz, String(record.konto))
        when KtoBlzCheck::OK
          break
        when KtoBlzCheck::UNKNOWN
          record.errors.add(attribute, ": #{options[:message] || I18n.t('errors.konto.error')}")
          record.errors.add(attribute, name)
          break
        when KtoBlzCheck::ERROR
          record.errors.add(attribute, ": #{options[:message] || "#{I18n.t('errors.konto.invalid')} (#{name})"}")
          break
        when KtoBlzCheck::BANK_NOT_KNOWN
          record.errors.add(attribute, ": #{options[:message] || I18n.t('errors.konto.bank_unknown')}")
          break
        end
      end
    end
  end
end
