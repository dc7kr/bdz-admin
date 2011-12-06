module ApplicationHelper

  def default_page_title
    title + ' - ' + subtitle
  end
  
  def title
    'BDZ Admin Interface'
  end
  
  def subtitle
    ''
  end

def corika_tr(entity,field,default)
    t("activerecord.attributes."+entity+"."+field, :default => t("activerecord.labels."+field, :default => default))
end
def link_back(path, txt)
    link_to image_tag('/images/icons/back.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end
def del_button(path) 
	link_to image_tag("web-app-theme/icons/cross.png", :alt => "#{t("web-app-theme.delete", :default=> "Delete")}") + " " + t("web-app-theme.delete", :default => "Delete"), path, :method => "delete", :class => "button", :confirm => "#{t("web-app-theme.confirm", :default => "Are you sure?")}"
end
def edit_button(path) 
	link_to image_tag("web-app-theme/icons/application_edit.png", :alt => "#{t("web-app-theme.edit", :default=> "Edit")}") + " " + t("web-app-theme.edit", :default=> "Edit"), path, :class => "button"

end

def link_to_edit(path, txt)
#    if user_signed_in?
                link_to image_tag('/images/icons/edit.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#        end
end

def link_to_show(path, txt)
        link_to image_tag('/images/icons/show.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end

def link_to_new(path, txt)
#    if user_signed_in?
          link_to image_tag('/images/icons/new.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#    end
end

def link_to_delete(path, txt, confirm )
#    if user_signed_in?
                link_to image_tag('/images/icons/delete.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path,:confirm => confirm
#        end
end

def format_date(date) 
  return date.strftime '%d.%m.%Y'
end

def format_time(time) 
  return time.strftime '%H:%M'
end

def sortable(column, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "current #{sort_direction}" : nil
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title , params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class }
end


end
