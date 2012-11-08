module ApplicationHelper

  def t_opts(group,field,data)
  
	tags = Array.new

	data.each do |d|
  		myarr = [ t(group+"."+field+"_"+d),d ]
		tags.push(myarr)
	end

	tags
  end
  def title
	if ENV["RAILS_ENV"] == "production" 
		"BDZ Admin Interface"
	else
		"Dev. Instance BDZ Admin (DON'T USE FOR PRODUCTION!)"
	end
  end

  def default_page_title
    title + ' - ' + subtitle
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


def link_to_up_path(txt,path)
	link_to image_tag('/assets/icons/up.svg', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end

def link_to_generated_download_path(txt,path)
	if can? :read, path then
		link_to image_tag('/assets/icons/download.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'}),path
	end
end
def link_to_download_path(txt,path,entity)
	if entity.has_attachment? and can? :read, entity then
    	link_to image_tag('/assets/icons/download.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
    end
end

def link_back(txt)
    link_to image_tag('/assets/icons/back.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),url_for(:back)
end
def submit_button(txt)
    image_tag("web-app-theme/icons/tick.png", :alt => txt)+txt
end
def cancel_button()
  link_to t("common.cancel"), url_for(:back), :class => "text_button_padding button"
end
def del_button(path,entity)
  if can? :destroy, entity  
	link_to image_tag("/assets/icons/delete.png", :alt => "#{t("common.delete", :default=> "Delete")}") + " " + t("common.delete", :default => "Delete"), path, :method => "delete", :class => "button", :confirm => "#{t("common.confirm", :default => "Are you sure?")}"
  end
end
def edit_button(path,entity) 
  if can? :update, entity
	link_to image_tag("web-app-theme/icons/application_edit.png", :alt => "#{t("common.edit", :default=> "Edit")}") + " " + t("common.edit", :default=> "Edit"), path, :class => "button"
  end

end

def link_to_edit(entity, txt)
    if can? :update, entity
                link_to image_tag('/assets/icons/edit.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),{ :id=>entity, :action=>'edit'}
    end
end

def link_to_edit_path(path,txt,entity)
    if can? :update, entity
                link_to image_tag('/assets/icons/edit.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
    end
end

def link_to_show_path(path,txt,entity)
	if can? :read, entity
        link_to image_tag('/assets/icons/show.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
    end
end

def link_to_show(entity,txt)
	if can? :read, entity
        link_to image_tag('/assets/icons/show.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),entity
    end
end

def link_to_new(path, txt, clazz)
	if can? :create, clazz
#    if user_signed_in?
          link_to image_tag('/assets/icons/new.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#    end
	end
end

def link_to_del_path(path, txt, confirm, entity)
    if can? :delete, entity
                link_to image_tag('/assets/icons/delete.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path, :confirm => confirm, :method => :delete
    end
end

def link_to_delete(entity, txt, confirm )
    if can? :delete, entity
                link_to image_tag('/assets/icons/delete.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),entity,:confirm => confirm, :method => :delete
    end
end

def format_date_time(date) 
  if ( date == nil ) 
    return ""
  else
    return date.strftime '%d.%m.%Y %H:%M Uhr'
  end
end

def format_date(date) 
  if ( date == nil ) 
    return ""
  else
    return date.strftime '%d.%m.%Y'
  end
end

def format_date_interval(startDate,endDate)
  retval = ""
  if ( startDate == nil ) then
	retval = "bis "
  else
    retval += format_date(startDate)
	retval += " - "
  end

  if ( endDate == nil ) then 
	return retval
  end
 
  retval += format_date(endDate)

  return retval
end

def format_time(time) 
  return time.strftime '%H:%M'
end

def format_currency(val,cur)
  return number_to_currency(val,:precision => 2,:locale => :de)
end

def format_int(val)
	return number_with_precision(val,:precision=>0)
end

def format_bool(val) 
  if (val) 
    return t("common.yes")
  else
    return t("common.no")
  end
end

def sortable(column, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "sort current #{sort_direction}" : "sort"
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title , params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class }
end

def tabActiveClass(current, expected, prefix)

	@retval =""
	if ( prefix ) then 
		@retval = prefix+" "
	end
	if ( current == expected ) then
		@retval << "active"
	end
	return @retval
end

def isAdmin?
	return (current_user != nil) && current_user.admin?
end

def readable?(entity)
    return can? :read, entity
end

end
