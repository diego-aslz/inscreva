ActiveAdmin.register Wiki do
  controller do
    def new
      @wiki = Wiki.new(params[:wiki])
      new!
    end
  end

  form do |f|
    f.inputs t(:details) do
      f.input :name
      f.input :title
      f.input :content
      f.input :event_id, as: :hidden
      f.input :wiki_id, as: :hidden
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :title
      row :event
      row :wiki
      row :content do
        markdown wiki
      end
    end
    attributes_table do
      row :wikis do
        link_to t(:'helpers.links.new'), new_wiki_path_for(wiki.event_id, wiki.id)
      end
    end
  end

end
