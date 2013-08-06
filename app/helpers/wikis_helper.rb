module WikisHelper
  def markdown(wiki)
    if wiki.is_a? Wiki
      redcarpet.render("#{wiki.content}\n[subscribe_link]: #{subscribe_path(wiki.event)}").html_safe
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

  def new_wiki_path_for(event_id, wiki_id=nil)
    params = ["wiki[event_id]=#{event_id}"]
    params << ["wiki[wiki_id]=#{wiki_id}"] if wiki_id
    "#{new_admin_wiki_path}?#{params.join '&'}"
  end
end
