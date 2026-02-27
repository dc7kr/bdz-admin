module NavHelper
  def nav_to_edit(entity, path = nil)
    return if not entity.present? 

    if entity.is_a?(Array)
      namespace = entity[0]
      entity = entity[1]
      return unless entity.present? and entity.id.present?
      # resolve by reflection
      path = send("edit_#{namespace}_#{entity.class.name.singularize.underscore}_path",entity) if path.nil?
    else
      return unless entity.id.present?
      path = send("edit_#{entity.class.name.singularize.underscore}_path",entity.id) if path.nil?
    end
      
    return if entity.nil? or entity.id.nil?

    return unless policy(entity).update?

    path = { action: "edit", controller: entity.class.name.underscore.pluralize, id: entity }  if path.nil?

    content_tag(:li, class: "nav-item") do 
      link_to path, :class => tabActiveClass(action_name,'edit',"nav-link") do
        concat(my_fa_icon("edit"))
        concat("&nbsp;".html_safe)
        concat(t("common.edit"))
      end
    end
  end

  def nav_to_new(entity_class, path = nil)
    return unless policy(entity_class).create?

    path = { action: "new", controller: entity_class.name.underscore.pluralize } if path.nil?

    content_tag(:li, class: "nav-item") do
      link_to path, :class => tabActiveClass(action_name,'new',"nav-link") do
        concat(my_fa_icon("plus"))
        concat("&nbsp;".html_safe)
        concat(t("common.new"))
      end
    end
  end

  def nav_to_show(entity, path = nil)
    
    return if not entity.present? or not entity.id.present?

    if entity.is_a?(Array)
      namespace = entity[0]
      entity = entity[1]
      path = "#{namespace}_#{entity.class.name.singularize.underscore}_path" if path.nil?
    end

    return if entity.nil? or entity.id.nil?

    return unless policy(entity).show?

    path = { action: "show", controller: entity.class.name.underscore.pluralize } if path.nil?

    content_tag(:li, class: "nav-item") do
      link_to path, class: tabActiveClass(action_name, "show", "nav-link") do 
        concat(my_fa_icon("eye"))
        concat("&nbsp;".html_safe)
        concat(t("common.show"))
      end
    end
  end

  def nav_to_list(entity_class, path = nil)
    return unless policy(entity_class).show?

    path = { action: "index", controller: entity_class.name.underscore.pluralize } if path.nil?

    link_to path, class: tabActiveClass(action_name, "index", "nav-link") do
       my_fa_icon("list")
    end
  end
end
