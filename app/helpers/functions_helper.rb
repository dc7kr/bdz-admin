module FunctionsHelper
  def render_address(contact)
    content_tag(:div, add, class: 'address')
    contact.name
    tag.br
  end
end
