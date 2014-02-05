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

  def replace_body(orig_params, subst) 

    substed_params = orig_params.clone

    body = substed_params["body"]

    subst.each do |s|
      logger.debug("Subst-Pattern:"+s[0])
      body = body.gsub(s[0],s[1])
    end

    substed_params["body"]=body

    return substed_params
  end

  def deliver_festival_mail(appl,mail_params,event_id,att_file,resultArray)
    @festival_concert = appl.festival_concert


    substitutes = {
      "%konzert%" => @festival_concert.label.to_s,
      "%konzert_zeit%" => I18n.l(@festival_concert.event_time),
      "%konzert_ort%" => @festival_concert.location,
      "%teilnehmer_name%" => appl.orch_name,
      "%probenzeit%" => appl.rehearsal_time.to_s
    }

    this_mail_params = replace_body(mail_params,substitutes)

    body = this_mail_params[:body]
    subject = this_mail_params[:subject]
    letter = att_file

    return deliver_email(appl.contact_person,subject,body,event_id,att_file,nil)
  end
end
