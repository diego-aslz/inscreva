class ErrorsController < ApplicationController
  def show
    @exception = env["action_dispatch.exception"]
    @status = request.path[/\/\d{3}/][1..-1]
    if %w(404 422 500).include? @status
      render action: @status
    else
      render action: 'default'
    end
  end
end
