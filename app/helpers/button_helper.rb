module ButtonHelper
  def link_to_edit_path(path,txt,entity)
      if can? :update, entity
          link_to content_tag(:span,"",:class=>"glyphicon glyphicon-edit"), path,:class =>"btn btn-xs btn-default"
      end
  end
  def link_to_download_path(txt,path,entity)
    if entity.has_attachment? and can? :read, entity then
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-download"),path,:class =>"btn btn-xs btn-default"
    end
  end

  def link_to_show_path(path,txt,entity)
    if can? :read, entity
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-list"),path,:class =>"btn btn-xs btn-default"
    end
  end

  def link_to_show(entity,txt=nil)
    if ( txt == nil ) then
      txt = t('common.show')
    end
    if can? :read, entity
          link_to content_tag(:span,"",:class=>"glyphicon glyphicon-list"), entity,:class=>"btn btn-xs btn-default"
      end
  end

  def link_to_new(path, txt, clazz)
    if can? :create, clazz
  #    if user_signed_in?
          link_to content_tag(:span,"",:class=>"glyphicon glyphicon-plus-sign"), path
  #    end
    end
  end

  def link_to_publish(entity,txt) 
    if can? :update, entity then
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-cloud-upload"),{:id=>entity, :action=>'publish'},{"data-type"=> :json, :remote => true,:class =>"btn btn-xs btn-default"}
    end
  end

  def link_to_delete(entity, txt=nil, confirm=nil )
      if txt == nil then
        txt = t('common.delete')
      end
      if  confirm == nil then 
        txt = t('common.delete_confirm')
      end
      if can? :delete, entity
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-remove"),entity,:confirm => confirm, :method => :delete, :remote=>true,  "data-type" => :json,:class=>"btn btn-xs btn-danger"
      end
  end

  def del_button(entity)
    del_button(entity,entity)
  end

  def del_button(path,entity)
    if can? :destroy, entity  
    link_to image_tag("/assets/icons/delete.png", :alt => t("common.delete")) + " " + t("common.delete"), path, :method => "delete", :class => "button", :confirm => t("common.confirm")
    end
  end

  def glyph_button(glyph, path,txt, type= :link)
    if type == :link 
      link_to path, :class => "btn btn-default" do 
        content_tag(:span,"",:class=>"glyphicon #{glyph}")+" #{txt}"
      end
    elsif type == :button
      button_tag(:type=>path,:class=>"btn btn-primary") do 
        content_tag(:span,"",class: "glyphicon #{glyph}")+" "+
        txt
      end
    end
  end

  def edit_button(path,entity) 
    if can? :update, entity
      glyph_button("glyphicon-edit", path, t("common.edit"))
    end
  end

  def submit_button(txt=t('common.save'))
    glyph_button("glyphicon-ok", "submit", txt,:button)
  end

  def cancel_button()
    link_to t("common.cancel"), url_for(:back), :class => "btn btn-default"
  end

end
