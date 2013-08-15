class ErrorsController < ApplicationController
  def show
    @exception = env["action_dispatch.exception"]
    render action: request.path[/\/\d{3}/][1..-1]
  end
end
