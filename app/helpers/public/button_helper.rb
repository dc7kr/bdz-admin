module Public::ButtonHelper 
  def cancel_button()
    link_to t("common.cancel"), url_for(:back), :class => "btn btn-default"
  end

end
