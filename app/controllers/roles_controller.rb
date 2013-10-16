class RolesController < InheritedResources::Base
  load_and_authorize_resource
  actions :all
  respond_to :html

  protected

  def resource_params
    return [] if request.get?
    [params.require(:role).permit(:name, :permission_ids)]
  end
end
