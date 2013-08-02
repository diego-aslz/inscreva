module WikisHelper
  def markdown(wiki)
    if wiki.is_a? Wiki
      redcarpet.render("#{wiki.content}\n[subscribe_link]: #{subscribe_path(wiki.event)}").html_safe
    else
      redcarpet.render(wiki).html_safe
    end
  end
end
