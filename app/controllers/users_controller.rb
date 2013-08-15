class UsersController < InheritedResources::Base
  load_and_authorize_resource
  respond_to :html

  def index
    @users = User.page(params[:page])
    @users = @users.search(params[:term]) unless params[:term].blank?
    @users = @users.not_subscribers if params[:subscribers].blank?
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    update!
  end
end
