module Ef::FestivalApplicationsHelper 

  def get_group_type_options(selected)
    options_for_select(
    [
      [t('festival_application.group_types.O'),"O"],
      [t('festival_application.group_types.E'), "E"],
      [t('festival_application.group_types.S'),"S"], 
      [t('festival_application.group_types.D'),"D"],
      [t('festival_application.group_types.T'), "T"] 
    ],:selected=>selected)
  end


  def display_group_visitor_type(part)
   vtype = display_visitor_type(part.visitor_type)

   gtype = display_group_type(part.group_type)

   return vtype+" ("+gtype+")"
  end

  def get_payment_status_options(selection)
    options_for_select([
      [t('festival_application.payment_states.N'),"N"],
      [t('festival_application.payment_states.P'),"P"],
      [t('festival_application.payment_states.F'),"F"],
      [t('festival_application.payment_states.S'),"S"],
    ],:selected=>selection)
  end
  def get_group_type_options(selection)
    options_for_select(
      [
		    [t('festival_application.group_types.O'),"O"],
		    [t('festival_application.group_types.E'), "E"],
		    [t('festival_application.group_types.S'),"S"], 
		    [t('festival_application.group_types.D'),"D"],
	    ],:selected => selection)
  end

  def get_visitor_type_options(selection)
    options_for_select(
      [
		    [t('festival_application.visitor_types.R'),"R"],
		    [t('festival_application.visitor_types.G'),"G"],
		    [t('festival_application.visitor_types.Y'),"Y"], 
		    [t('festival_application.visitor_types.V'),"V"],
		    [t('festival_application.visitor_types.O'),"O"],
	    ], :selected=>selection)
  end

  def display_visitor_type(type)
    if type != nil then
      t 'festival_application.visitor_types.'+type
    else
      ""
    end
  end

  def display_group_type(type)
    if type != nil then
      t 'festival_application.group_types.'+type
    else
      ""
    end
  end
end
