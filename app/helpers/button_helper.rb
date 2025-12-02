module ButtonHelper
  def link_to_edit(entity, txt = "", btn_class = "btn-sm btn-outline-dark")
    txt = raw("&nbsp;") + txt if txt.present?

    if entity.is_a?(Array)
      namespace = entity[0]
      entity = entity[1]
      path = "edit_#{namespace}_#{entity.class.name.singularize.underscore}_path"
    else
      path = "edit_#{entity.class.name.singularize.underscore}_path"
    end

    return unless can? :update, entity

    link_to send(path, entity), class: "btn #{btn_class}" do
      my_fa_icon("edit") + raw("&nbsp;") +
        txt
    end
  end

  def link_to_edit_path(path, _txt, entity)
    return unless can? :update, entity

    link_to my_fa_icon("edit"), path, class: "btn btn-sm btn-outline-dark"
  end

  def link_to_download_path(_txt, path, entity)
    return unless entity.has_attachment? && can?(:read, entity)
    link_to path, class: "btn btn-sm btn-outline-dark", data: { turbo: false } do
      concat(my_fa_icon("download"))
      if not _txt.nil? 
        concat(raw("&nbsp;"))
        concat(_txt)
      end
    end
  end

  def link_to_show_path(path, _txt, entity)
    return unless can? :read, entity

    link_to my_fa_icon("eye"), path, class: "btn btn-sm btn-outline-dark"
  end

  def link_to_show(entity, txt = nil)
    t("common.show") if txt.nil?
    return unless can? :read, entity

    link_to my_fa_icon("eye"), entity, class: "btn btn-sm btn-outline-dark"
  end

  def link_to_new(path, _txt, clazz)
    return unless can? :create, clazz

    #    if user_signed_in?
    link_to my_fa_icon("plus"), path, class: "btn btn-sm btn-outline-dark"
    #    end
  end

  def nav_to_show(entity)
    path = { action: "show", controller: entity.class.name.underscore.pluralize }

    return unless can? :show, entity

    link_to my_fa_icon("eye"), path, class: tabActiveClass(@current_action, "new", "nav-link")
  end

  def nav_to_new(entity_clazz, path = nil)
    path = { action: "new", controller: entity_clazz.name.underscore.pluralize } if path.nil?
    return unless can? :create, entity_clazz

    link_to my_fa_icon("plus"), path, class: tabActiveClass(@current_action, "new", "nav-link")
  end

  def nav_to_list(entity_clazz, path = nil)
    path = { action: "index", controller: entity_clazz.name.underscore.pluralize } if path.nil?

    link_to my_fa_icon("list"), path, class: tabActiveClass(@current_action, "index", "nav-link")
  end

  def link_to_publish(entity, _txt)
    return unless can? :update, entity

    link_to content_tag(:span, "", class: "glyphicon glyphicon-cloud-upload"), { id: entity, action: "publish" },
            { "data-type" => :json, :remote => true, :class => "btn btn-sm btn-default" }
  end

  def link_to_del_path(path, entity, _remote = false, authorize = true, cfm = true, txt = nil, confirm = nil)
    link_class = "delete-#{entity.class.model_name}"
    label_or_default(txt, "common.delete")
    confirm = label_or_default(confirm, "common.confirm_delete")
    return unless can?(:delete, entity) || !authorize

    link_to my_fa_icon("trash-alt"), path, data: { 'turbo-method': :delete, 'turbo-confirm': cfm ? confirm : nil },
                                           class: "btn btn-sm btn-danger #{link_class}"
  end

  def link_to_delete(entity, txt = nil, confirm = nil)
    t("common.delete") if txt.nil?
    confirm = t("common.delete_confirm") if confirm.nil?

    if entity.is_a?(Array)
      namespace = entity[0]
      entity = entity[1]
      path = "#{namespace}_#{entity.class.name.singularize.underscore}_path"
    else
      path = "#{entity.class.name.singularize.underscore}_path"
    end

    return unless can? :delete, entity

    link_to my_fa_icon("trash-alt"),
            send(path, entity), data: { 'turbo-method': :delete, 'turbo-confirm': confirm }, class: "btn btn-sm btn-danger"
  end

  def del_button(entity)
    del_button(entity, entity)
  end

  def del_button(path, entity)
    return unless can? :destroy, entity

    glyph_button("trash-alt", path, t("common.delete"), true, :button, "btn btn-sm btn-danger")
  end

  def glyph_button(glyph, path, txt, _turbo_links = true, type = :link, clazz = nil)
    clazz = "btn-primary" if clazz.nil?

    if type == :link
      link_to path, class: "btn #{clazz}" do
        my_fa_icon(glyph) + " #{txt}"
      end
    elsif type == :button

      button_tag(link: path, class: "btn #{clazz}") do
        my_fa_icon(glyph) + raw("&nbsp;") + txt
      end
    end
  end

  def edit_glyph_link(path, entity)
    return unless can? :update, entity

    glyph_button("edit", path, t("common.edit"), true, :link, "btn btn-sm btn-outline-dark")
  end

  def del_glyph_link(path, entity)
    return unless can? :destroy, entity

    glyph_button("trash-alt", path, t("common.delete"), true, :link, "btn btn-sm btn-outline-dark")
  end

  def edit_button(path, entity)
    return unless can? :update, entity

    glyph_button("edit", path, t("common.edit"), true, :button, "btn btn-sm btn-outline-dark")
  end

  def submit_button(txt = t("common.save"), _form = nil)
    glyph_button("check", "submit", txt, true, :button, "btn btn-primary")
  end

  def cancel_button
    link_to t("common.cancel"), url_for(:back), class: "btn btn-default"
  end

  def wizard_back_button(path, txt = t("common.back"))
    glyph_button("step-backward", path, txt, true, :link, "btn-secondary")
  end

  def wizard_img_button(path, txt, img)
    link_to "#{image_tag(img, { size: '16x16', alt: txt, title: txt, class: 'btn' })} #{txt}", path,
            class: "btn btn-default"
  end

  def wizard_forward_button(txt = t("common.save"), path)
    glyph_button("step-forward", path, txt, true, :link, "btn-primary")
  end

  def wizard_del_button(path, txt, _entity)
    link_to my_fa_icon("times") + txt, path, confirm: t("common.delete_confirm"), class: "btn btn-danger"
  end

  def icon_link_to(glyph, txt, path)
    link_to "#{my_fa_icon(glyph)} #{txt}", path, class: "btn btn-default"
  end
end
