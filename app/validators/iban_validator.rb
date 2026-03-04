class IbanValidator < ActiveModel::EachValidator

  # Official IBAN lengths per country
  IBAN_LENGTHS = {
    "AL"=>28,"AD"=>24,"AT"=>20,"AZ"=>28,"BH"=>22,"BE"=>16,"BA"=>20,"BR"=>29,
    "BG"=>22,"CR"=>22,"HR"=>21,"CY"=>28,"CZ"=>24,"DK"=>18,"DO"=>28,"EE"=>20,
    "FO"=>18,"FI"=>18,"FR"=>27,"GE"=>22,"DE"=>22,"GI"=>23,"GR"=>27,"GL"=>18,
    "GT"=>28,"HU"=>28,"IS"=>26,"IE"=>22,"IL"=>23,"IT"=>27,"JO"=>30,"KZ"=>20,
    "KW"=>30,"LV"=>21,"LB"=>28,"LI"=>21,"LT"=>20,"LU"=>20,"MK"=>19,"MT"=>31,
    "MR"=>27,"MU"=>30,"MC"=>27,"MD"=>24,"ME"=>22,"NL"=>18,"NO"=>15,"PK"=>24,
    "PS"=>29,"PL"=>28,"PT"=>25,"QA"=>29,"RO"=>24,"SM"=>27,"SA"=>24,"RS"=>22,
    "SK"=>24,"SI"=>19,"ES"=>24,"SE"=>24,"CH"=>21,"TN"=>24,"TR"=>26,"AE"=>23,
    "GB"=>22,"VG"=>24
  }.freeze

  def validate_each(record, attribute, value)
    # record.errors.add attribute, I18n.t('errors.iban.required') if value.blank?

    if value.blank?
      return unless record.has_attribute?(:za) && (record.za == "L")

      record.errors.add attribute, I18n.t("errors.iban.required_for_dd")
      return
    end

    iban = normalize(value)

    if not basic_format_valid?(iban)
        record.errors.add attribute, I18n.t("errors.iban.invalid_format")
        return
    end

    if not country_length_valid?(iban)

        country = iban[0..1]
        expected = IBAN_LENGTHS[country]

        record.errors.add attribute, I18n.t("errors.iban.invalid_length", expected: expected)
        return
    end

    if not mod97_valid?(iban)
        record.errors.add attribute, I18n.t("errors.iban.invalid_value")
        return
    end
  end

  private
  def normalize(iban)
    iban.gsub(/\s+/, "").upcase
  end

  def basic_format_valid?(iban)
    iban.match?(/\A[A-Z]{2}\d{2}[A-Z0-9]+\z/)
  end

  def country_length_valid?(iban)
    country = iban[0..1]
    expected_length = IBAN_LENGTHS[country]
    expected_length && iban.length == expected_length
  end

  # Official IBAN MOD-97 check
  def mod97_valid?(iban)
    rearranged = iban[4..] + iban[0..3]

    numeric_string = rearranged.chars.map do |char|
      if char =~ /[A-Z]/
        (char.ord - 55).to_s  # A=10, B=11, ..., Z=35
      else
        char
      end
    end.join

    mod97(numeric_string) == 1
  end

  # Compute mod 97 safely for very large numbers
  def mod97(number_string)
    remainder = 0
    number_string.each_char do |digit|
      remainder = (remainder * 10 + digit.to_i) % 97
    end
    remainder
  end
end
