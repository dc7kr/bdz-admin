module ApplicationHelper

  include CountryHelper
  include ButtonHelper

  def is_production?
	  ENV["RAILS_ENV"] == "production"
  end

  def t_opts(group,field,data)
    tags = Array.new

    data.each do |d|
        myarr = [ t(group+"."+field+"_"+d),d ]
      tags.push(myarr)
    end

    tags
  end

  def title
    if is_production?
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

  def attr_heading(clazz, attr)
    clazz.human_attribute_name(attr)
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
	link_to content_tag(:span,"",:class=>"glyphicon glyphicon-arrow-up"), path
end

def link_to_generated_download_path(txt,path)
	if can? :read, path then
    link_to content_tag(:span,"",:class=>"glyphicon glyphicon-download"),path,:class =>"btn btn-xs btn-default"
	end
end


def icon_link(txt,img,path)
    link_to image_tag(img, {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end


def link_back(txt)
	icon_link(txt,'/assets/icons/back.png',url_for(:back))
end

def wizard_img_button(path,txt,img)
    link_to image_tag(img, {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} )+" "+txt,path, :class => "text_button_padding button"
end

def wizard_forward_button(txt,path)
    link_to image_tag('web-app-theme/icons/tick.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} )+" "+txt,path, :class => "text_button_padding button"
end

def wizard_del_button(path,txt,entity)
    link_to image_tag("/assets/icons/delete.png", {:size=>'16x16', :alt => txt, :title=>txt, :class=>'btn'})+" "+txt,path, :class => "test_button_padding button", :confirm => t("common.delete_confirm")
end

def back_button(path) 
  link_to image_tag("icons/back.png", :alt => t("common.back"))+" "+t("common.back"), path, :class => "button"
end

def link_to_edit(entity, txt=nil)
	if txt == nil then
		txt = t('common.edit')
	end
    if can? :update, entity
        link_to content_tag(:span,"",:class=>"glyphicon glyphicon-edit"), { :id=>entity, :action=>'edit'},:class =>"btn btn-xs btn-default"
    end
end


def label_or_default(txt, key)
	if (txt == nil ) then
		txt=t(key)
	end

	txt
end

def link_to_del_path(path, entity, remote=false, authorize=true, cfm=true,txt=nil, confirm=nil )
	txt=label_or_default(txt,'common.delete')
	confirm=label_or_default(confirm,'common.confirm_delete')
    if can? :delete, entity or not authorize
      img = '/assets/icons/delete.png'
      img_hash = {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'}
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-remove-sign"), path, :confirm => cfm ? confirm : nil, :method => :delete, :remote => remote,:class =>"btn btn-xs btn-danger"
    end
end


def format_date_time(date) 
  if ( date == nil ) 
    return ""
  else
    return date.strftime '%d.%m.%Y %H:%M Uhr'
  end
end

def format_date_only(date)
  if (date.nil?)
    "---"
  else
    return date.strftime '%d.%m.%Y'
  end
end
def format_date(date) 
  if ( date == nil ) 
    "---"
  else
    l date
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
  if (time.nil?) then
    return "---"
  else
    return time.strftime '%H:%M'
  end
end

def format_currency(val,cur=nil)
  return number_to_currency(val,:precision => 2,:locale => :de)
end

def format_int(val)
	return number_with_precision(val,:precision=>0)
end

def format_bool(val) 
  if (val) 
    return t("common.yes_")
  else
    return t("common.no_")
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

def sanitize_url(url)
	if url == nil || url.length == 0 then
		return "#"
	end
	if not url.starts_with?("http://") then
		"http://"+url
	else
		url
	end
end

	def labeled_data(entity,name,tag)
		label_str = I18n.t(name+"."+tag.to_s)
#		content = content_tag(:td,:class=>"label",label_str)
		content_tag(:tr,content)	
	end


    def autocomplete_input(attributes={})
        #*need* object: this form's object : "person"
        #*need* instance: searcheable object : 'account'
        # instance_key: primary key of this instance : 'account_id'
        # value: original or default value for instance : 'Yahoo Corp.'
        # value_key: original or default value for instance_key: 252
        #*need* ajax_url: remote url for ajax call without format: url_for(:controller=> :accounts, :action=> :search, :id=>'all')
        # ajax_query_additional_params (Array): ["maxRows: 7", "anything :20"]
        #*need* ajax_query_searchable_param Object's string (String): "name" (@person.account.name)
        #*need* ajax_query_searchable_param_key Object's foreign key (String): "id" (@person.account.id)
        # min_length minimal chars to start searching: 2   
         
        if attributes.nil? then return false end
        if attributes.empty? then return false end
        object=attributes[:object]
        instance=attributes[:instance]
        if object.nil? or instance.nil? then return false end   
        object=object.to_s.downcase
        instance=instance.to_s.downcase
        instance_key=attributes[:instance_key] || instance + "_id"
        value=attributes[:value] || ""
        value_key=attributes[:value_key] || ""
        value_key_html=""
        unless value_key.to_s.empty? then
            value_key_html=" value=\""+value_key.to_s+"\""
        end
        ajax_url=attributes[:ajax_url]
        ajax_query_additional_params=attributes[:ajax_query_additional_params] || ""
        ajax_query_searchable_param=attributes[:ajax_query_searchable_param] || "name"
        ajax_query_searchable_param_key=attributes[:ajax_query_searchable_param_key] || "id"
        min_length=attributes[:min_length] || 2
         
        ajax_query_additional_params_formatted=""
        unless ajax_query_additional_params.nil? then
            case ajax_query_additional_params
                when Array then
                    i=0
                    ajax_query_additional_params.each do |aqap|
                        if i==0 then
                            ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + aqap.to_s
                        else
                            ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + ",\n" + aqap.to_s
                        end
                        i=i.next
                    end
                when String then
                    ajax_query_additional_params_formatted=ajax_query_additional_params
                when Hash then
                    i=0
                    ajax_query_additional_params.each do |aqap_key,aqap_value|
                        if i==0 then
                            ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + aqap_key.to_s + ": " + aqap_value.to_s
                        else
                            ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + ",\n" + aqap_key.to_s + ": " + aqap_value.to_s
                        end
                        i=i.next
                    end
            end
        end
        jquery_request_data_params="data: {\n"
        unless ajax_query_additional_params_formatted.empty? then
            jquery_request_data_params=jquery_request_data_params + ajax_query_additional_params_formatted + ",\n"
        end
        jquery_request_data_params=jquery_request_data_params + "#{ajax_query_searchable_param}: request.term\n},"
        search_field_id="search_#{object}_#{instance}"
        value_div_id="#{object}_#{instance}_log"
        hidden_field_id="#{object}_#{instance_key}"
        hidden_field_name="#{object}[#{instance_key}]"
        function_log_name="log_#{object}_#{instance}"
         
        html_text = <<HTML1
<table><tbody><tr>
    <td><input id="#{search_field_id}" class="ui-autocomplete-input"/></td>
    <td><div id="#{value_div_id}" class="ui-widget-content">#{value}</div></td>
</tr></tbody></table>
<input type="hidden" id="#{hidden_field_id}" name="#{hidden_field_name}" #{value_key_html} >
 
HTML1
         
         js_text = <<JS1
         
$(function() {
 
    function #{function_log_name}( label, id ) {
        $( "##{value_div_id}" ).html(label);
        $( "##{hidden_field_id}").val(id);
    }
 
    $( "##{search_field_id}" ).autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: "#{ajax_url}.json",
                dataType: "json",
                #{jquery_request_data_params}
                success: function( data ) {
                    response( $.map( data, function( item ) {
                        return {
                            label: item.#{ajax_query_searchable_param},
                            value: item.#{ajax_query_searchable_param},
                            id: item.#{ajax_query_searchable_param_key}
                        }
                    }));
                }
            });
        },
        minLength: #{min_length},
        select: function( event, ui ) {
            if (ui.item) {
                #{function_log_name}( ui.item.value, ui.item.id );
            } else {
                #{function_log_name}( this.value, this.value );
            }
        },
        open: function() {
            $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });
});
         
JS1
    concat(raw(javascript_tag(js_text)))
    concat(raw(html_text))
    end

  def form_err_class(resource, field) 
    if resource.errors[field].present? then
      "has-error"
    else
      ""
    end
  end

  def get_salutation_options(selected)
    options_for_select( [
        [t('common.salutations.M'),"M"],  
        [t('common.salutations.W'), "W"]
      ],
      :selected=>selected)
  end

  def form_wrapped_field(form,resource,field, input) 
      label = form.label field, nil,:class => "col-sm-12 col-md-3 control-label"
      css_class="form-group row"
      if not resource.is_a? Symbol then
        if resource.errors[field].present? 
          css_class+=" has-error"
        end
      end

      input_wrap = content_tag(:div, input, :class=>"col-sm-12 col-md-9")
      content_tag(:div, label+input_wrap, class: css_class) 
  end

  def form_my_field(form, resource, field, type=:text, extra_class=nil)

      css_class = "form-control"

      if not extra_class.nil?
        css_class+=" "+extra_class
      end
      input = nil

      if type == :text 
        input = form.text_field field, :class =>  css_class
      elsif type == :number
        input = form.number_field field, :class =>  css_class
      elsif type == :password
        input = form.password_field field, :class =>  css_class
      elsif type == :url
        input = form.url_field field, :class =>  css_class
      elsif type == :email
        input = form.email_field field, :class =>  css_class
      elsif type == :date
        input = form.text_field field, :class =>  css_class+" date_field datePicker"
      elsif type == :checkbox
        input = form.check_box field, :class => css_class
      elsif type == :file
        # TODO: use Bootstrap 4 File Field once upgraded
        input = form.file_field field
      elsif type == :static
        input = content_tag(:p , resource[field],class: "form-control-static")
      end

      form_wrapped_field(form, resource, field, input)
  end

  def form_my_textarea(form, resource, field, cols,rows)
      input = form.text_area field, :class => 'form-control', :cols=>cols, :rows=>rows
      form_wrapped_field(form,resource, field, input)
  end

  def form_my_file(form, resource, field, cols,rows)
      input = form.file_field field, :class => 'form-control'
      form_wrapped_field(form,resource, field, input)
  end

  def form_my_select(form, resource, field,options) 
    label = form.label field, nil,:class => "col-sm-12 col-md-3 control-label"

    css_class = "form-control"

    input = form.select field, options, {}, {class: css_class}
    form_wrapped_field(form, resource, field, input)
  end

  def map_flash_type(type)
    if type == :notice
      return "alert-success"
    elsif type == :alert or type == :error
      return "alert-danger"
    elsif type == :warning
      return "alert-warning"
    else ""
      Rails.logger.warn("Unsupported flash type: #{type}")
      return "UNSUPPORTED: <#{type}>"
    end
  end
 
  def entity_row(entity, field,type=nil) 
    sym = entity.class.name.underscore.to_sym
    content_tag :div, :class => "row" do

      data = nil
      if type.nil? 
        data = entity[field]
      elsif type == :date
        data = l entity[field]
      elsif type == :mailto
        data = mail_to entity[field],entity[field]
      elsif type == :currency
        data = format_currency entity[field],"EUR"
      elsif type == :boolean
        data = format_bool entity[field]
      elsif type == :url
        data = link_to entity[field],entity[field]
      end 

      concat(content_tag(:div, label(sym, field), :class => "col-md-3 text-right"))
      concat(content_tag(:div, data,:class => "col-md-9"))
    end
  end

end
