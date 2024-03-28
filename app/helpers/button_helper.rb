module ButtonHelper
  def link_to_edit(entity, txt=nil)
    if txt == nil then
      txt = t('common.edit')
    end

    
    if entity.kind_of?(Array) then 
      namespace = entity[0]
      entity = entity[1]
      path = "edit_#{namespace}_#{entity.class.name.singularize.underscore}_path"
    else 
      namespace = nil
      path = "edit_#{entity.class.name.singularize.underscore}_path"
    end

    if can? :update, entity
      link_to my_fa_icon("edit"), send(path, entity), :class =>"btn btn-sm btn-outline-dark"
    end
  end


  def link_to_edit_path(path,txt,entity)
      if can? :update, entity
          link_to my_fa_icon("edit"), path,:class =>"btn btn-sm btn-outline-dark"
      end
  end


  def link_to_download_path(txt,path,entity)
    if entity.has_attachment? and can? :read, entity then
      link_to my_fa_icon("download"),path,:class =>"btn btn-sm btn-outline-dark", data: { turbolinks:false }
    end
  end

  def link_to_show_path(path,txt,entity)
    if can? :read, entity
      link_to my_fa_icon("eye"),path,:class =>"btn btn-sm btn-outline-dark"
    end
  end

  def link_to_show(entity,txt=nil)
    if ( txt == nil ) then
      txt = t('common.show')
    end
    if can? :read, entity
          link_to my_fa_icon("eye"), entity, :class=> "btn btn-sm btn-outline-dark"
      end
  end

  def link_to_new(path, txt, clazz)
    if can? :create, clazz
  #    if user_signed_in?
          link_to my_fa_icon("plus"), path, :class => "btn btn-sm btn-outline-dark"
  #    end
    end
  end

  def nav_to_show(entity) 
    path = { :action=>"show", :controller=> entity.class.name.underscore.pluralize }

    if can? :show, entity
      link_to my_fa_icon("eye"), path, :class => tabActiveClass(@current_action,"new", "nav-link")
    end

  end

  def nav_to_new(entity_clazz,path=nil)
    if path.nil?
      path = { :action=>"new", :controller=> entity_clazz.name.underscore.pluralize }
    end
    if can? :create, entity_clazz
      link_to my_fa_icon("plus"), path, :class => tabActiveClass(@current_action,"new", "nav-link")
    end
  end

  def nav_to_list(entity_clazz,path=nil)
    if path.nil?
      path = { :action=>"index", :controller=> entity_clazz.name.underscore.pluralize }
    end

    link_to my_fa_icon("list"), path, :class => tabActiveClass(@current_action,"index", "nav-link")
  end

  def link_to_publish(entity,txt) 
    if can? :update, entity then
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-cloud-upload"),{:id=>entity, :action=>'publish'},{"data-type"=> :json, :remote => true,:class =>"btn btn-sm btn-default"}
    end
  end

  def link_to_del_path(path, entity, remote=false, authorize=true, cfm=true,txt=nil, confirm=nil )
    link_class = "delete-#{entity.class.model_name}"
    txt=label_or_default(txt,'common.delete')
    confirm=label_or_default(confirm,'common.confirm_delete')
      if can? :delete, entity or not authorize
        link_to my_fa_icon("trash-alt"), path, data: { "turbo-method": :delete, "turbo-confirm": cfm ? confirm : nil },:class =>"btn btn-sm btn-danger #{link_class}"
      end
  end


  def link_to_delete(entity, txt=nil, confirm=nil )
      if txt.nil? then
        txt = t('common.delete')
      end
      if  confirm.nil? then 
        confirm = t('common.delete_confirm')
      end

      if entity.kind_of?(Array)
        namespace = entity[0]
        entity = entity[1]
        path = "#{namespace}_#{entity.class.name.singularize.underscore}_path" 
      else
        namespace = nil
        path= "#{entity.class.name.singularize.underscore}_path"
      end

      if can? :delete, entity
        link_to my_fa_icon("trash-alt"),
        send(path, entity), data: { "turbo-method": :delete, "turbo-confirm": confirm }, class: "btn btn-sm btn-danger"
      end
  end

  def del_button(entity)
    del_button(entity,entity)
  end

  def del_button(path,entity)
    if can? :destroy, entity  
      glyph_button("trash-alt", path, t("common.delete"),true,:button,"btn btn-sm btn-danger")
    end
  end

  def glyph_button(glyph, path,txt, turbo_links=true, type= :link, clazz=nil)
    if clazz.nil? then
      clazz = "btn-default"
    end

    if type == :link 
      link_to path, :class => "btn "+clazz do 
        my_fa_icon(glyph)+" #{txt}"
      end
    elsif type == :button
      
      button_tag(:link=>path,:class=>"btn #{clazz}") do 
        my_fa_icon(glyph)+" "+txt
      end
    end
  end

  def edit_glyph_link(path,entity) 
    if can? :update, entity
      glyph_button("edit", path, t("common.edit"), true, :link, "btn btn-sm btn-outline-dark")
    end 
  end
  
  def del_glyph_link(path,entity) 
    if can? :destroy, entity
      glyph_button("trash-alt", path, t("common.delete"), true, :link, "btn btn-sm btn-outline-dark")
    end 
  end


  def edit_button(path,entity) 
    if can? :update, entity
      glyph_button("edit", path, t("common.edit"), true, :button, "btn btn-sm btn-outline-dark")
    end
  end

  def submit_button(txt=t('common.save'),form=nil)
    glyph_button("check", "submit", txt,true,:button, "btn btn-primary")
  end

  def cancel_button()
    link_to t("common.cancel"), url_for(:back), :class => "btn btn-default"
  end

  def wizard_back_button(path,txt=t("common.back"))
    glyph_button("step-backward", path, txt,true,:link,"btn-secondary")
  end

  def wizard_img_button(path,txt,img)
      link_to image_tag(img, {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} )+" "+txt,path, :class => "btn btn-default"
  end

  def wizard_forward_button(txt=t('common.save'),path)
    glyph_button("step-forward", path, txt,true,:link,"btn-primary")
  end

  def wizard_del_button(path,txt,entity)
      link_to my_fa_icon("times")+txt,path,:confirm => t("common.delete_confirm"), :class=>"btn btn-danger"
  end

  def icon_link_to(glyph, txt, path)
      link_to my_fa_icon(glyph)+" "+txt,path,:class=>"btn btn-default"
  end

end
