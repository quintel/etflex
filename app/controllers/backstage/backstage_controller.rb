# A general base class for all Backstage controllers. Sets up layouts,
# languages, authentication, etc. All controllers in controllers/backstage
# should inherit from this class.
#
class Backstage::BackstageController < ApplicationController
  layout 'backstage'
  helper :backstage

  respond_to :html

  # FILTERS ------------------------------------------------------------------

  before_filter :authenticate_user!
  before_filter :require_admin!

  # Checks that the authenticated user is an admin, otherwise just renders
  # a 404.
  #
  def require_admin!
    raise User::NotAuthorised unless current_user.admin?
  end

end # Backstage::BackstageController
