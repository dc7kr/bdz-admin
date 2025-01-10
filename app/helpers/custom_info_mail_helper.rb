module CustomInfoMailHelper
  def group_options
    options_for_select(
      [
        [t('custom_info_mail.groups.A'), 'A'],
        [t('custom_info_mail.groups.O'), 'O'],
        [t('custom_info_mail.groups.E'), 'E'],
        [t('custom_info_mail.groups.T'), 'T']
      ],
      selected: 'A'
    )
  end
end
