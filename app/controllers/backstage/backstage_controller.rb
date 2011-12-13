# A general base class for all Backstage controllers. Sets up layouts,
# languages, authentication, etc. All controllers in controllers/backstage
# should inherit from this class.
#
class Backstage::BackstageController < ApplicationController
  layout 'backstage'
  respond_to :html
end
