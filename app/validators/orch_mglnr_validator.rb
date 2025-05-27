class OrchMglnrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value
      nr = value

      r = false
      digit = (nr % 1000) / 100

      if record.orch_type == "L" && digit != 2
        record.errors.add(attribute, (options[:message] || I18n.t("errors.mglnr.require_land_orch")))
      elsif record.orch_type == "K" && digit != 1
        record.errors.add(attribute, (options[:message] || I18n.t("errors.mglnr.require_koop")))
      else
        r = true
      end
      record.errors.add(attribute, (options[:message] || I18n.t("errors.mglnr.invalid"))) unless r
    else
      record.errors.add(attribute, (options[:message] || I18n.t("errors.mglnr.required")))
      nil
    end
  end
end
