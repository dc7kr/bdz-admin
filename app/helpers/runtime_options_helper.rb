module RuntimeOptionsHelper
  def runtime_option_value(value)
    case value
    when true then t("runtime_option.true")
    when false then t("runtime_option.false")
    when nil then "–"
    when Time, ActiveSupport::TimeWithZone then l(value, format: :short)
    else value.to_s
    end
  end
end
