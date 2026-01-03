module NavHelper
  def nav_to_edit(entity)

    if not can? :edit, entity
      return ""
    end

    content_tag(:li, class: "nav-item") do 
      if entity.is_a?(Array)
        namespace = entity[0]
        entity = entity[1]
        path = "edit_#{namespace}_#{entity.class.name.singularize.underscore}_path"
      else
        path = "edit_#{entity.class.name.singularize.underscore}_path"
      end

      link_to t("common.edit"), path, :class => tabActiveClass(@current_action,'edit',"nav-link")
    end
  end

  def nav_to_new(entity_clazz)

    if not can? :create, entity_clazz
      return ""
    end

    path = "new_#{entity_clazz.name.singularize.underscore}_path"

    content_tag(:li, class: "nav-item") do
      link_to t("common.new"), path, :class => tabActiveClass(@current_action,'new',"nav-link")
    end
  end

  def nav_to_new_path(entity_clazz, new_path)
    if not can? :create, entity_clazz
      return ""
    end

    content_tag(:li, class: "nav-item") do
      link_to t("common.new"), path, :class => tabActiveClass(@current_action,'new',"nav-link")
    end
  end
end
