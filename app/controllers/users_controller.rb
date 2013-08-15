class UsersController < InheritedResources::Base
  load_and_authorize_resource
  respond_to :html

  def index
    @users = User.search(params[:term]) unless params[:term].blank?
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    update!
  end
end
