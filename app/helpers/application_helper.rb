module ApplicationHelper
  def page_header(text)
    content_tag(:div, content_tag(:h1, text), class: 'page-header')
  end

  def form_actions(&block)
    content_tag(:div, class: 'form-actions', &block)
  end

  def icon_tag(icon)
    content_tag(:span, '', class: "glyphicon glyph#{icon}")
  end

  def link_to_add(klass, path, options = {})
    link_to t(:'helpers.links.new'), path,
        class: (options[:class] || 'btn btn-primary') if can? :new, klass
  end

  def link_to_edit(model, path, options = {})
    link_to t('.edit', :default => t("helpers.links.edit")),
        path, class: (options[:class] || 'btn btn-warning') if can? :edit, model
  end

  def minilink_to_edit(model, path, options = {})
    link_to icon_tag('icon-pencil').html_safe,
        path, :class => (options[:class] || 'btn btn-xs btn-warning'),
        title: t(:'helpers.links.edit') if can? :edit, model
  end

  def minilink_to_destroy(model, options = {})
    link_to icon_tag('icon-trash').html_safe, model, method: :delete, data: { confirm:
            t(:'helpers.links.confirm', model: (options[:model] ||
                model.class.model_name.human), value: options[:value]) },
        class: (options[:class] || 'btn btn-xs btn-danger'),
        title: t(:'helpers.links.destroy') if can? :destroy, model
  end

  def link_to_back(options = {})
    link_to (options[:text] || t('.back', :default => t("helpers.links.back"))),
        options.fetch(:path) { :back }, :class => 'btn btn-default'
  end

  def redcarpet
    ApplicationHelper.redcarpet
  end

  def self.redcarpet
    @@redcarpet ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        autolink: true, tables: true)
  end

  def locale_flag(locale)
    image_tag "#{locale}.png", alt: locale, width: "16", height: "16" if locale && !locale.blank?
  end

  def priority_countries
    %w[BRA ARG BOL CHL COL CUB MEX PER PRY URY VEN]
  end

  def abbr(text, options={})
    options = {size: 15, ending: '...'}.merge options
    size = options[:size]
    ab = options[:abbr]
    ending = options[:ending]
    if text.size <= size.to_i
      text
    else
      content_tag :abbr, "#{ab || text[0..size-1]}#{ending}", title: text
    end
  end
end
