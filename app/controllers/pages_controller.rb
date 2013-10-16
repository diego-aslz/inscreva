# -*- encoding : utf-8 -*-
class PagesController < InheritedResources::Base
  class NotFound < StandardError; end
  load_and_authorize_resource except: :present
  belongs_to :event, shallow: true
  actions :all
  respond_to :html

  def new
    @page = Page.new
    @page.event = @event
    @page.files.build
  end

  def create
    create! { event_pages_path(@page.event) }
  end

  def update
    update! { event_pages_path(@page.event) }
  end

  def index
    @pages = @pages.search(params[:term]) unless params[:term].blank?
    index!
  end

  def present
    @event = Event.find_by_identifier params[:event]
    not_found(params[:event]) unless @event
    if params[:page]
      @page = @event.pages.find_by_name(params[:page])
    else
      if @page = @event.main_page
        redirect_to present_event_page_path(params[:event], @page.name)
        return
      end
    end
    not_found(params[:page]) unless @page
  end

  protected

  def resource_params
    return [] if request.get?
    [params.require(:page).permit(:content, :name, :page_id, :event_id, :title,
      :main, :event_name, :language, files_attributes: [
        :file, :name
      ])]
  end

  def not_found(page=nil)
    raise NotFound, (page.nil? ? nil : "Não há Evento ou Página com o identificador '#{page}'")
  end
end
