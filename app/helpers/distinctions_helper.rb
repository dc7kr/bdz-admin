module DistinctionsHelper
  def link_to_generate_path(txt, path)
    link_to image_tag("/assets/icons/new.png", { size: "16x16", alt: txt, title: txt, class: "btn" }), path,
            data: { tubolinks: false }
  end

  def generate_button(txt, path, _entity)
    link_to path, class: "btn btn-primary", data: { turbolinks: false } do
      content_tag(:span, "", class: "glyphicon glyphicon-open-file") + " #{txt}"
    end
  end
end
