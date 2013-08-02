module ApplicationHelper
  def page_header(text)
    content_tag(:div, content_tag(:h1, text), class: 'page-header')
  end

  def form_actions(&block)
    content_tag(:div, class: 'form-actions', &block)
  end

  def icon_tag(icon)
    content_tag(:i, '', class: icon)
  end

  def link_to_edit(model, path, options = {})
    link_to t('.edit', :default => t("helpers.links.edit")),
        path, :class => (options[:class] || 'btn') if can? :edit, model
  end

  def link_to_back(options = {})
    link_to (options[:text] || t('.back', :default => t("helpers.links.back"))),
        (options[:path] || :back), :class => 'btn'
  end

  def input(form, attribute, options={})
    options[:label] ||= (options[:model_class] || form.object.class).human_attribute_name attribute
    options.delete :model_class
    form.input attribute, options
  end

  def redcarpet
    @@redcarpet ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        autolink: true, tables: true)
  end
end
