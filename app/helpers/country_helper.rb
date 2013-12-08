module CountryHelper
  def translated_country(ccode,locale="de") 
      if ccode.nil? then
        return ""
      end

      ctry = ISO3166::Country[ccode]
      if ctry.nil? then
        ""
      else
        ctry.translations[locale] 
      end
  end
end
