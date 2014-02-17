class FieldFillsController < ApplicationController
  load_and_authorize_resource

  def download
    fill = FieldFill.find params[:id]
    if fill.file?
      send_file fill.file.to_s
    else
      redirect_to :back
    end
  end
end
