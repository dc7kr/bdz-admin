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

def c_t(entity,field)
	c_t(entity,field,nil)
end

def c_t(entity,field,default)
	if (default )
		t(entity+"."+field,:default => default)
	else
		t(entity+"."+field,:default=>"#"+field+"#" )
	end
end
def corika_tr(entity,field,default)
    t("activerecord.attributes."+entity+"."+field, :default => t("activerecord.labels."+field, :default => default))
end


def link_back(path, txt)
    link_to image_tag('/assets/icons/back.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end
def submit_button(txt)
    image_tag("web-app-theme/icons/tick.png", :alt => txt)+txt
end
def del_button(path) 
	link_to image_tag("/assets/icons/delete.png", :alt => "#{t("common.delete", :default=> "Delete")}") + " " + t("common.delete", :default => "Delete"), path, :method => "delete", :class => "button", :confirm => "#{t("common.confirm", :default => "Are you sure?")}"
end
def edit_button(path) 
	link_to image_tag("web-app-theme/icons/application_edit.png", :alt => "#{t("common.edit", :default=> "Edit")}") + " " + t("common.edit", :default=> "Edit"), path, :class => "button"

end

def link_to_edit(path, txt)
#    if user_signed_in?
                link_to image_tag('/assets/icons/edit.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#        end
end

def link_to_show(path, txt)
        link_to image_tag('/assets/icons/show.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end

def link_to_new(path, txt)
#    if user_signed_in?
          link_to image_tag('/assets/icons/new.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#    end
end

def link_to_delete(path, txt, confirm )
#    if user_signed_in?
                link_to image_tag('/assets/icons/delete.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path,:confirm => confirm
#        end
end

def format_date(date) 
  if ( date == nil ) 
    return ""
  else
    return date.strftime '%d.%m.%Y'
  end
end

def format_time(time) 
  return time.strftime '%H:%M'
end

def format_currency(val,cur)
  str = "%.2f" % val
  str << ' ' << cur
  return str
end

def format_bool(val) 
  if (val) 
    return "&#x2713;"
  else
    return "-"
  end
end

def sortable(column, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "sort current #{sort_direction}" : "sort"
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title , params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class }
end


end
