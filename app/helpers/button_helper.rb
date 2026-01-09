module ButtonHelper
  def link_to_edit(entity, path=nil, txt:nil, btn_class:"btn-sm btn-outline-dark", authz: true, turbo: false)

    if entity.is_a?(Array)
      namespace = entity[0]
      entity = entity[1]
      # resolve by reflection
      path = send("edit_#{namespace}_#{entity.class.name.singularize.underscore}_path",entity) if path.nil?
    else
      path = send("edit_#{entity.class.name.singularize.underscore}_path",entity) if path.nil?
    end
      
    if authz == true
      return unless policy(entity).update? 
    end

    html_options = { 
      class: "btn #{btn_class}"
    }

    if turbo
      html_options["data"]={
        turbo: true,
        "turbo_stream": true
      }
    else
      # escape turbo_stream if turbo inactive
      html_options["format"] = :html
    end


    link_to path, html_options do
      concat(my_fa_icon("edit"))
      if not txt.nil?
        concat(raw("&nbsp;"))
        concat(txt)
      end
    end
  end

  def download_button(url, txt = nil, btn_class = "btn-primary")
    link_to url, class: "btn #{btn_class}" do
      concat(my_fa_icon("download"))

      if not txt.nil?
        concat(raw("&nbsp;"))
        concat(txt)
      end
    end
  end

  def link_to_download_path(entity, path, txt=nil, btn_class="btn-sm btn-outline-dark")
    return unless entity.has_attachment? and policy(entity).show?
    link_to path, class: "btn #{btn_class}", data: { turbo: false } do
      concat(my_fa_icon("download"))
      if not txt.nil?
        concat(raw("&nbsp;"))
        concat(txt)
      end
    end
  end

  def link_to_show(entity, path = nil, txt = nil, btn_class = "btn-sm btn-outline-dark")
    return unless policy(entity).show?

    if entity.is_a?(Array)
      namespace = entity[0]
      entity = entity[1]
      # resolve by reflection
      path = send("#{namespace}_#{entity.class.name.singularize.underscore}_path",entity) if path.nil?
    else
      path = send("#{entity.class.name.singularize.underscore}_path",entity) if path.nil?
    end
      
    link_to path, class: "btn btn-sm #{btn_class}" do 
      concat(my_fa_icon("eye"))
      if not txt.nil?
        concat(raw("&nbsp;"))
        concat(txt)
      end
    end
  end

  def link_to_new(entity, path=nil, txt:nil, btn_class:"btn-sm btn-outline-dark", authz: true, turbo: false)

    if authz == true
      return unless policy(entity).create? 
    end

    path = "new_#{entity.class.name.underscore.singularize}_path" if path.nil?

    html_options = { 
      class: "btn #{btn_class}"
    }

    if turbo
      html_options["data"]={
        turbo: true,
        "turbo_stream": true
      }
    end

    link_to path, html_options do
      concat(my_fa_icon("plus"))

      if not txt.nil?
        concat(raw("&nbsp;"))
        concat(txt)
      end
    end
  end


  def link_to_publish(entity, txt)
    return unless policy(entity).update?

    link_to content_tag(:span, "", class: "glyphicon glyphicon-cloud-upload"), { id: entity, action: "publish" },
            { "data-type" => :json, :remote => true, :class => "btn btn-sm btn-default" }
  end

  def link_to_delete(p_entity, path=nil, txt: nil, confirm: nil, btn_class: "btn-sm btn-danger", authz: true)
    confirm = t("common.delete_confirm") if confirm.nil?
    
    if p_entity.is_a?(Array)
      namespace = p_entity[0]
      entity = p_entity[1]
    else
      entity = p_entity
    end

    path = send("#{entity.class.name.singularize.underscore}_path",entity) if path.nil?

    return unless not authz or policy(p_entity).destroy?

    link_to path, data: { 'turbo-method': :delete, 'turbo-confirm': confirm }, class: "btn #{btn_class}" do 
      concat(my_fa_icon("trash-alt"))
      if not txt.nil?
        concat(raw("&nbsp;"))
        concat(txt)
      end
    end
  end

  def del_button(entity)
    del_button(entity, entity)
  end

  def del_button(path, entity)
    return unless policy(entity).destroy?

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
    return unless policy(entity).update?

    glyph_button("edit", path, t("common.edit"), true, :link, "btn btn-sm btn-outline-dark")
  end

  def del_glyph_link(path, entity)
    return unless policy(entity).destroy?

    glyph_button("trash-alt", path, t("common.delete"), true, :link, "btn btn-sm btn-outline-dark")
  end

  def edit_button(path, entity)
    return unless policy(entity).update?

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
