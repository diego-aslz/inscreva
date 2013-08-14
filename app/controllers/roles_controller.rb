class RolesController < InheritedResources::Base
  load_and_authorize_resource
  actions :all
  respond_to :html
end
