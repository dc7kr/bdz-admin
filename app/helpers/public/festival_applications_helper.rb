module Public::FestivalApplicationsHelper

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

end
