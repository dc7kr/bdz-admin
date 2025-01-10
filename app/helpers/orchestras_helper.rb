module OrchestrasHelper
  def link_to_orchestra_acct(orchestra, _txt)
    return unless can? :update, orchestra

    link_to content_tag(:span, '', class: 'glyphicon glyphicon-euro'),
            orchestra_member_account_bookings_url(orchestra), class: 'btn btn-xs btn-default'
  end
end
