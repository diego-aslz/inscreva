class PagesController < InheritedResources::Base
  load_and_authorize_resource except: :present
  belongs_to :event, shallow: true
  actions :all
  respond_to :html

  def new
    @page = Page.new
    @page.page_files.build
  end

  def create
    create! { event_pages_path(@page.event) }
  end

  def update
    update! { event_pages_path(@page.event) }
  end

  def present
    @event = Event.find_by_identifier params[:event]
    not_found unless @event
    if params[:page]
      @page = @event.pages.find_by_name(params[:page])
    else
      if @page = @event.main_page
        redirect_to present_event_page_path(params[:event], @page.name)
        return
      end
    end
    not_found unless @page
  end
end
