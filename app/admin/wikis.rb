ActiveAdmin.register Wiki do
  controller do
    def new
      @wiki = Wiki.new(event_id: params[:event_id], wiki_id: params[:wiki_id])
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
  end

end
