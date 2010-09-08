class HTML5FormBuilder < Formtastic::SemanticFormBuilder
  def name_for(method)
    "#{object_name}[#{method.to_s}]"
  end

protected

  def basic_input_helper(form_helper_method, type, method, options) #:nodoc:
    html_options = options.delete(:input_html) || {}
    html_options = default_string_options(method, type).merge(html_options) if [:numeric, :string, :password, :text].include?(type)

    self.label(method, options_for_label(options)) <<
    self.send(form_helper_method, method, html_options)
  end

  def input_with_html5_required(method, options = {})
    options[:required] = method_required?(method) unless options.key?(:required)
    if options[:required]
      (options[:input_html] ||= {})[:required] = 'required'
    end
    input_without_html5_required(method, options)
  end

  alias_method_chain :input, :html5_required

  def destroy_input(method, options)
    options[:label] = "<a class=\"button negative\" onclick=\"remove_fields(this); return false;\" href='#'>#{options[:label]}</a>".html_safe
    #(options[:label_html] ||= {})[:onclick] = "remove_fields(this)"
    #(options[:label_html] ||= {})[:class] = [:negative]
    basic_input_helper(:hidden_field, :string, method, options)
  end

  def numeric_input(method, options)
    basic_input_helper(:number_field, :numeric, method, options)
  end
  #def number_field(method, options)
  #  ::ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag('number', options)
  #end

  def email_input(method, options)
    basic_input_helper(:email_field, :string, method, options)
  end
  #def email_field(method, options)
  #  ::ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag('email', options)
  #end

  def url_input(method, options)
    basic_input_helper(:url_field, :string, method, options)
  end
  #def url_field(method, options)
  #  ::ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag('url', options)
  #end

  def date_input(method, options)
    basic_input_helper(:date_field, :string, method, options)
  end
  def date_field(method, options)
    self.text_field(method, options.merge({:type => :date}))
  end
end

Formtastic::SemanticFormHelper.builder = HTML5FormBuilder
