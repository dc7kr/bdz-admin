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
end
