class ApplicationController < ActionController::Base
  protect_from_forgery

  # A temporary action used to verify that Haml, RSpec, and other dependencies
  # are correctly configured.
  #
  # GET /sanity
  #
  def sanity
  end

end
