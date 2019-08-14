module FestivalMailsHelper

  def group_options
    options_for_select([
      [t("festival_mail.groups.FA"),"FA"],
      [t("festival_mail.groups.FP"),"FP"], 
      [t("festival_mail.groups.FR"),"FR"],
      [t("festival_mail.groups.FO"),"FO"],
      [t("festival_mail.groups.FG"),"FG"],
      [t("festival_mail.groups.FJ"),"FJ"],
      [t("festival_mail.groups.FS"),"FS"]
    ], 
    :selected=>"FP") 
  end

  def replace_body(orig_body, subst) 
    body = orig_body
    subst.each do |s|
      #logger.debug("Subst-Pattern:"+s[0])
      body = body.gsub(s[0],s[1])
    end

    return body
  end

  def prepare_body(appl,body)
    @festival_concert = appl.festival_concert

    
    substitutes = {
      "%id%" => appl.id.to_s,
      "%teilnehmer_name%" => appl.orch_name
    }

    if not appl.rehearsal_time.nil? 
      substitutes["%probenzeit%"] = appl.rehearsal_time.to_s
    end

    if not @festival_concert.nil? 
      substitutes["%konzert%"] = @festival_concert.label.to_s
      substitutes["%konzert_zeit%"] = I18n.l(@festival_concert.event_time)
      substitutes["%konzert_ort%"] = @festival_concert.location
    end

    return replace_body(body,substitutes)
  end
end
