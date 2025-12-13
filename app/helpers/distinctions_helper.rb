module DistinctionsHelper
  def link_to_generate_path(txt, path)
    link_to path, data: { turbo: false } do
      my_fa_icon("new") # image_tag("/assets/icons/new.png", { size: "16x16", alt: txt, title: txt, class: "btn" }),
    end
  end

  def generate_button(txt, path, _entity)
    link_to path, class: "btn btn-primary", data: { turbo: false } do
      content_tag(:span, "", class: "glyphicon glyphicon-open-file") + " #{txt}"
    end
  end
end
