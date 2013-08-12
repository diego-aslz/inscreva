class LocalesController < ApplicationController
  def show
    session[:locale] = params[:locale]
    redirect_to :back
  end
end
