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
      "%konzert%" => @festival_concert.label.to_s,
      "%konzert_zeit%" => I18n.l(@festival_concert.event_time),
      "%konzert_ort%" => @festival_concert.location,
      "%teilnehmer_name%" => appl.orch_name,
      "%probenzeit%" => appl.rehearsal_time.to_s
    }

    return replace_body(body,substitutes)
  end
end
