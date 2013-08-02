class WikisController < ApplicationController
  load_and_authorize_resource

  def show
    @event = Event.find_by_identifier params[:event]
    not_found unless @event
    if params[:wiki]
      @wiki = @event.wikis.find_by_name(params[:wiki])
    else
      @wiki = @event.wikis.where(wiki_id: nil).first
    end
    not_found unless @wiki
  end
end
