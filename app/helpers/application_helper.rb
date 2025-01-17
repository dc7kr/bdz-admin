module ApplicationHelper
  include CountryHelper
  include ButtonHelper
  include FontAwesomeHelper

  def is_production?
    ENV['RAILS_ENV'] == 'production'
  end

  def is_staging?
    ENV['RAILS_ENV'] == 'staging'
  end

  def nil_safe_value(value)
    if value.nil?
      0
    else
      value
    end
  end

  def t_opts(group, field, data)
    tags = []

    data.each do |d|
      myarr = [I18n.t("#{group}.#{field}_#{d}"), d]
      tags.push(myarr)
    end

    tags
  end

  def title
    if is_production?
      'BDZ Admin Interface'
    elsif is_staging?
      'Staging Instance BDZ Admin Interface'
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

  def c_t(entity, field)
    c_t(entity, field, nil)
  end

  def c_t(entity, field, default)
    if default
      t(entity + '.' + field, default: default)
    else
      t(entity + '.' + field, default: '#' + field + '#')
    end
  end

  def corika_tr(entity, field, default)
    t('activerecord.attributes.' + entity + '.' + field,
      default: t('activerecord.labels.' + field, default: default))
  end

  def link_to_up_path(_txt, path)
    link_to my_fa_icon('arrow-up'), path, class: 'nav-link'
  end

  def link_to_generated_download_path(_txt, path)
    return unless can? :read, path

    link_to my_fa_icon('download'), path, class: 'btn btn-sm btn-outline-default', data: { turbolinks: false }
  end

  def icon_link(txt, img, path)
    link_to image_tag(img, { size: '16x16', alt: txt, title: txt, class: 'btn' }), path
  end

  def link_back(txt)
    icon_link(txt, '/assets/icons/back.png', url_for(:back))
  end

  def back_button(path)
    link_to image_tag('icons/back.png', alt: t('common.back')) + ' ' + t('common.back'), path, class: 'button'
  end

  def label_or_default(txt, key)
    txt = t(key) if txt.nil?

    txt
  end

  def format_date_time(date)
    return '' if date.nil?

    date.strftime '%d.%m.%Y %H:%M Uhr'
  end

  def format_date_only(date)
    return date.strftime '%d.%m.%Y' unless date.nil?

    '---'
  end

  def format_date(date)
    if date.nil?
      '---'
    else
      l date
    end
  end

  def format_date_interval(startDate, endDate)
    retval = ''
    if startDate.nil?
      retval = 'bis '
    else
      retval += format_date(startDate)
      retval += ' - '
    end

    return retval if endDate.nil?

    retval += format_date(endDate)

    retval
  end

  def format_time(time)
    return '---' if time.nil?

    time.strftime '%H:%M'
  end

  def format_currency(val, _cur = nil)
    number_to_currency(val, precision: 2, locale: :de)
  end

  def format_int(val)
    number_with_precision(val, precision: 0)
  end

  def format_bool(val)
    return t('common.yes_') if val

    t('common.no_')
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? " sort current #{sort_direction}" : ' sort'
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, params.merge(sort: column, direction: direction, page: nil).permit(:sort, :direction, :page),
            { class: css_class }
  end

  def nav_action_class(action, prefix = nil)
    if @current_action == action
      "#{prefix} active"
    else
      prefix
    end
  end

  def tabActiveClass(current, expected, prefix = nil)
    prefix = 'nav-link' if prefix.nil?

    retval = prefix + ' '

    retval << 'active' if current == expected

    retval
  end

  def isAdmin?
    !current_user.nil? && current_user.admin?
  end

  def readable?(entity)
    can? :read, entity
  end

  def sanitize_url(url)
    return '#' if url.nil? || url.length == 0

    if url.starts_with?('http://')
      url
    else
      'http://' + url
    end
  end

  def labeled_data(_entity, name, tag)
    I18n.t(name + '.' + tag.to_s)
    #		content = content_tag(:td,:class=>"label",label_str)
    content_tag(:tr, content)
  end

  def autocomplete_input(attributes = {})
    # *need* object: this form's object : "person"
    # *need* instance: searcheable object : 'account'
    # instance_key: primary key of this instance : 'account_id'
    # value: original or default value for instance : 'Yahoo Corp.'
    # value_key: original or default value for instance_key: 252
    # *need* ajax_url: remote url for ajax call without format: url_for(:controller=> :accounts, :action=> :search, :id=>'all')
    # ajax_query_additional_params (Array): ["maxRows: 7", "anything :20"]
    # *need* ajax_query_searchable_param Object's string (String): "name" (@person.account.name)
    # *need* ajax_query_searchable_param_key Object's foreign key (String): "id" (@person.account.id)
    # min_length minimal chars to start searching: 2

    return false if attributes.nil?
    return false if attributes.empty?

    object = attributes[:object]
    instance = attributes[:instance]
    return false if object.nil? or instance.nil?

    object = object.to_s.downcase
    instance = instance.to_s.downcase
    instance_key = attributes[:instance_key] || (instance + '_id')
    value = attributes[:value] || ''
    value_key = attributes[:value_key] || ''
    value_key_html = ''
    value_key_html = ' value="' + value_key.to_s + '"' unless value_key.to_s.empty?
    ajax_url = attributes[:ajax_url]
    ajax_query_additional_params = attributes[:ajax_query_additional_params] || ''
    ajax_query_searchable_param = attributes[:ajax_query_searchable_param] || 'name'
    ajax_query_searchable_param_key = attributes[:ajax_query_searchable_param_key] || 'id'
    min_length = attributes[:min_length] || 2

    ajax_query_additional_params_formatted = ''
    unless ajax_query_additional_params.nil?
      case ajax_query_additional_params
      when Array
        i = 0
        ajax_query_additional_params.each do |aqap|
          ajax_query_additional_params_formatted = if i == 0
                                                     ajax_query_additional_params_formatted + aqap.to_s
                                                   else
                                                     ajax_query_additional_params_formatted + ",\n" + aqap.to_s
                                                   end
          i = i.next
        end
      when String
        ajax_query_additional_params_formatted = ajax_query_additional_params
      when Hash
        i = 0
        ajax_query_additional_params.each do |aqap_key, aqap_value|
          ajax_query_additional_params_formatted = if i == 0
                                                     ajax_query_additional_params_formatted + aqap_key.to_s + ': ' + aqap_value.to_s
                                                   else
                                                     ajax_query_additional_params_formatted + ",\n" + aqap_key.to_s + ': ' + aqap_value.to_s
                                                   end
          i = i.next
        end
      end
    end
    jquery_request_data_params = "data: {\n"
    jquery_request_data_params = jquery_request_data_params + ajax_query_additional_params_formatted + ",\n" unless ajax_query_additional_params_formatted.empty?
    jquery_request_data_params += "#{ajax_query_searchable_param}: request.term\n},"
    search_field_id = "search_#{object}_#{instance}"
    value_div_id = "#{object}_#{instance}_log"
    hidden_field_id = "#{object}_#{instance_key}"
    hidden_field_name = "#{object}[#{instance_key}]"
    function_log_name = "log_#{object}_#{instance}"

    html_text = <<~HTML1
      <table><tbody><tr>
          <td><input id="#{search_field_id}" class="ui-autocomplete-input"/></td>
          <td><div id="#{value_div_id}" class="ui-widget-content">#{value}</div></td>
      </tr></tbody></table>
      <input type="hidden" id="#{hidden_field_id}" name="#{hidden_field_name}" #{value_key_html} >
      #{' '}
    HTML1

    js_text = <<~JS1
      #{'         '}
      $(function() {
      #{' '}
          function #{function_log_name}( label, id ) {
              $( "##{value_div_id}" ).html(label);
              $( "##{hidden_field_id}").val(id);
          }
      #{' '}
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
      #{'         '}
    JS1
    concat(raw(javascript_tag(js_text)))
    concat(raw(html_text))
  end

  def form_err_class(resource, field)
    if resource.errors[field].present?
      'has-error'
    else
      ''
    end
  end

  def get_salutation_options(selected)
    options_for_select([
                         [t('common.salutations.M'), 'M'],
                         [t('common.salutations.W'), 'W']
                       ],
                       selected: selected)
  end

  def get_country_options(_selected = nil)
    ISO3166::Country.all.collect { |c| [c.translations['en'], c.alpha2] }
  end

  def wrapped_no_label(_form, resource, _field, input)
    unless resource.is_a? Symbol
    end

    content_tag(:div, input)
  end

  def form_wrapped_field(form, resource, field, input)
    label = form.label field, nil, class: 'col-sm-12 col-md-3 control-label'
    css_class = 'form-group row'
    css_class += ' has-error' if !resource.is_a?(Symbol) && resource.errors[field].present?

    input_wrap = content_tag(:div, input, class: 'col-sm-12 col-md-9')
    content_tag(:div, label + input_wrap, class: css_class)
  end

  def form_my_field(form, resource, field, type = :text, extra_class = nil)
    css_class = 'form-control'

    css_class += ' ' + extra_class unless extra_class.nil?
    input = nil

    if type == :text
      input = form.text_field field, class: css_class
    elsif type == :number
      input = form.number_field field, class: css_class
    elsif type == :currency
      input = form.number_field field, class: css_class, step: 0.01
    elsif type == :password
      input = form.password_field field, class: css_class
    elsif type == :url
      input = form.url_field field, class: css_class
    elsif type == :email
      input = form.email_field field, class: css_class
    elsif type == :datetime
      input = form.datetime_field field, class: css_class + ' date_field datePicker'
    elsif type == :date
      input = form.text_field field, class: css_class + ' date_field datePicker'
    elsif type == :checkbox
      input = form.check_box field, class: css_class
    elsif type == :file
      # TODO: use Bootstrap 4 File Field once upgraded
      input = form.file_field field
    elsif type == :static
      input = content_tag(:p, resource[field], class: 'form-control-static')
    end

    wrapped_no_label(form, resource, field, input)
  end

  def form_my_textarea(form, resource, field, cols, rows)
    input = form.text_area field, class: 'form-control', cols: cols, rows: rows
    form_wrapped_field(form, resource, field, input)
  end

  def form_my_file(form, resource, field, _cols, _rows)
    input = form.file_field field, class: 'form-control'
    form_wrapped_field(form, resource, field, input)
  end

  def form_my_select(form, resource, field, options)
    form.label field, nil, class: 'col-sm-12 col-md-3 control-label'

    css_class = 'form-control'

    input = form.select field, options, {}, { class: css_class }
    form_wrapped_field(form, resource, field, input)
  end

  def map_flash_type(type)
    if type == :notice
      'alert-success'
    elsif %i[alert error].include?(type)
      'alert-danger'
    elsif type == :warning
      'alert-warning'
    else
      Rails.logger.warn("Unsupported flash type: #{type}")
      "UNSUPPORTED: <#{type}>"
    end
  end

  def custom_entity_row(label, value)
    content_tag :div, class: 'row' do
      concat(content_tag(:div, content_tag(:label, label), class: 'col-md-3 text-end'))
      concat(content_tag(:div, value, class: 'col-md-9'))
    end
  end

  def entity_row(entity, field, type = nil, label_sym = nil)
    sym = entity.class.name.underscore.to_sym

    label = if label_sym.nil?
              label(sym, field)
            else
              label(sym, label_sym)
            end

    content_tag :div, class: 'row' do
      data = nil
      tmp = entity.send(field) unless entity.nil?

      if type.nil?
        data = tmp
      elsif type == :date
        data = if tmp.nil?
                 '---'
               else
                 l tmp
               end
      elsif type == :mailto
        data = mail_to tmp, tmp
      elsif type == :currency
        data = format_currency tmp, 'EUR'
      elsif type == :boolean
        data = format_bool tmp
      elsif type == :url
        data = link_to tmp, tmp
      elsif type == :select
        data = 'TODO'
      elsif type == :country
        ctry = ISO3166::Country[tmp]
        data = if ctry.nil?
                 '---'
               else
                 ctry.translations[I18n.locale.to_s]
               end
      end

      concat(content_tag(:div, label, class: 'col-md-3 text-end'))
      concat(content_tag(:div, data, class: 'col-md-9'))
    end
  end

  def invoice_item_row(item)
    content_tag :div, class: 'row' do
      count = item.count

      count = 0 if count.nil?

      concat(content_tag(:div, item.label, class: 'col-md-3 text-end'))
      concat(content_tag(:div, count.to_s, class: 'col-md-1 text-end'))
      concat(content_tag(:div, 'x', class: 'col-md-1'))
      concat(content_tag(:div, format_currency(item.price, '€'), class: 'col-md-2 text-end'))
      concat(content_tag(:div, format_currency(count * item.price, '€'), class: 'col-md-2 text-end'))
    end
  end

  def calculation_row(entity, field, unit_price)
    sym = entity.class.name.underscore.to_sym

    count = entity.send(field)

    count = 0 if count.nil?

    calculation_row_fixed(label(sym, field), count, unit_price)
  end

  def calculation_row_fixed(label, count, unit_price)
    content_tag :div, class: 'row' do
      concat(content_tag(:div, label, class: 'col-md-3 text-end'))
      concat(content_tag(:div, count.to_s, class: 'col-md-1 text-end'))
      concat(content_tag(:div, 'x', class: 'col-md-1'))
      concat(content_tag(:div, format_currency(unit_price, '€'), class: 'col-md-2 text-end'))
      concat(content_tag(:div, format_currency(count * unit_price, '€'), class: 'col-md-2 text-end'))
    end
  end

  def calculation_sum(label, price)
    content_tag :div, class: 'row' do
      concat(content_tag(:div, label, class: 'col-md-3 text-end'))
      concat(content_tag(:div, '', class: 'col-md-4'))
      concat(content_tag(:div, format_currency(price, '€'), class: 'col-md-2 text-end sum'))
    end
  end

  def bootstrap_class_for(flash_type)
    map = {
      'success' => 'alert-success',
      'error' => 'alert-danger',
      'alert' => 'alert-warning',
      'notice' => 'alert-info',
      'info' => 'alert-info'
    }

    Rails.logger.debug { "Flash-type: #{flash_type}" }
    map[flash_type] || flash_type.to_s
  end

  def t_update_success(entity)
    I18n.t('common.update_success', entity: t(entity, count:1))
  end
end
