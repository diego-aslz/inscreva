class UsersController < InheritedResources::Base
  load_and_authorize_resource except: :ahead
  respond_to :html

  def index
    @users = User.page(params[:page])
    @users = @users.search(params[:term]) unless params[:term].blank?
    @users = @users.not_subscribers if params[:subscribers].blank?
  end

  def ahead
    authorize! :update, Event
    @users = User.by_name(params[:term]).select([:id, :name]).order(:name)
    ar = []
    for e in @users.limit(20) do
      ar << {id: e.id, name: e.name}
    end
    render json: ar
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    update!
  end

  protected

  def resource_params
    return [] if request.get?
    [params.require(:user).permit(:email, :password, :password_confirmation,
      :remember_me, :name, :admin)]
  end
end
