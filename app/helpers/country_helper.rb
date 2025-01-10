module CountryHelper
  def translated_country(ccode, locale = 'de')
    return '' if ccode.nil?

    ctry = ISO3166::Country[ccode]
    if ctry.nil?
      ''
    else
      t_ctry = ctry.translations[locale]
      t_ctry = ctry.translations['en'] if t_ctry.nil?
      t_ctry
    end
  end

  def translated_state(ccode, state, _locale = 'de')
    return '' if state.nil? or ccode.nil?

    ctry = ISO3166::Country[ccode]

    tr_state = ctry.states[state]

    tr_state['name']
  end

  def state_options_for_country(country_code)
    country = ISO3166::Country[country_code]

    states = []

    country.states.each do |id, data|
      Rails.logger.debug(data)
      states << [data['name'], id]
    end

    states
  end
end
