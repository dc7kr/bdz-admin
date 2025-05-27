module FestivalMailsHelper
  def group_options
    options_for_select([
                         [t('festival_mail.groups.FA'), 'FA'],
                         [t('festival_mail.groups.FP'), 'FP'],
                         [t('festival_mail.groups.FR'), 'FR'],
                         [t('festival_mail.groups.FO'), 'FO'],
                         [t('festival_mail.groups.FG'), 'FG'],
                         [t('festival_mail.groups.FJ'), 'FJ'],
                         [t('festival_mail.groups.FS'), 'FS']
                       ],
                       selected: 'FP')
  end

end
