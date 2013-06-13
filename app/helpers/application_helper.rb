module ApplicationHelper
  def text_page_header(text)
    content_tag(:div, content_tag(:h1, text), class: 'page-header')
  end

  def icon_tag(icon)
    content_tag(:i, '', class: icon)
  end
end
