module CountryHelper
  def translated_country(ccode) 
      if ccode.nil? then
        return ""
      end

      ctry = ISO3166::Country[ccode]
      if ctry.nil? then
        ""
      else
        ctry.translations["de"] 
      end
  end
end
