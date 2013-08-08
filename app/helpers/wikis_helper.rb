module WikisHelper
  def markdown_footer(wiki)
    str = ""
    if wiki.files.any?
      str += "\n\n## #{t(:attachment).pluralize}\n\n"
      for file in wiki.files
        str += "* #{link_to file.name, file.file.url}\n"
      end
    end
    "#{str}\n[subscribe_link]: #{subscribe_path(wiki.event)}"
  end

  def markdown(wiki)
    if wiki.is_a? Wiki
      redcarpet.render("#{wiki.content}#{markdown_footer(wiki)}").html_safe
    else
      redcarpet.render(wiki).html_safe
    end
  end

  def link_to_wiki(wiki)
    link_to wiki.title, present_event_wiki_path(wiki.event.identifier, wiki.name)
  end

  def wiki_tree_node(wiki, last=true)
    res = wiki.wiki.nil? ? '' : wiki_tree_node(wiki.wiki, false)
    res + content_tag(:li, class: (last ? 'active' : nil)) do
      if last
        wiki.title
      else
        "#{link_to_wiki(wiki)} <span class=\"divider\">/</span>".html_safe
      end
    end
  end

  def wiki_tree(wiki)
    content_tag :ul, class: 'breadcrumb' do
      wiki_tree_node(wiki).html_safe
    end if wiki.wiki
  end
end
