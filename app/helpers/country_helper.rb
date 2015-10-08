module CountryHelper
  def translated_country(ccode,locale="de") 
      if ccode.nil? then
        return ""
      end

      ctry = ISO3166::Country[ccode]
      if ctry.nil? then
        ""
      else
        t_ctry = ctry.translations[locale]
        if t_ctry.nil? then
          t_ctry = ctry.translations['en']
        end
        return t_ctry
      end
  end

  def translated_state(ccode,state,locale="de")
    if state.nil? or ccode.nil? then
      return ""
    end
    
    ctry = ISO3166::Country[ccode]

    tr_state  = ctry.states[state]

    tr_state["name"]
  end
  def state_options_for_country(country_code)
    country = ISO3166::Country[country_code]

    states = Array.new

    statearr = country.states.each do |id,data|
      Rails.logger.debug(data)
      states << [ data["name"],id ]
    end

    states
  end
end
