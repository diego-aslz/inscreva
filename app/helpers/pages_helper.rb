module PagesHelper
  def markdown_footer(page)
    str = ""
    if page.files.any?
      str += "\n\n## #{t(:attachment).pluralize}\n\n"
      for file in page.files
        str += "* #{link_to file.name, file.file.url, target: :_blank}\n"
      end
    end
    "#{str}\n[subscribe_link]: #{subscribe_path(page.event)}"
  end

  def markdown(page)
    if page.is_a? Page
      redcarpet.render("#{page.content}#{markdown_footer(page)}").html_safe
    else
      redcarpet.render(page).html_safe
    end
  end

  def link_to_page(page)
    link_to page.title, present_event_page_path(page.event.identifier, page.name)
  end

  def page_tree_node(page, last=true)
    res = page.page.nil? ? '' : page_tree_node(page.page, false)
    res + content_tag(:li, class: (last ? 'active' : nil)) do
      if last
        page.title
      else
        "#{link_to_page(page)} <span class=\"divider\">/</span>".html_safe
      end
    end
  end

  def page_tree(page)
    content_tag :ul, class: 'breadcrumb' do
      page_tree_node(page).html_safe
    end if page.page
  end
end
