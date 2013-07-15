class FilesController < ApplicationController
  authorize_resource class: false

  def show
    send_file "/tmp/files/#{params[:id]}/#{params[:file_name]}"
  end
end
