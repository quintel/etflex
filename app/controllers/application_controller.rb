class ApplicationController < ActionController::Base
  protect_from_forgery

  include ETFlex::LocaleController
  include ETFlex::GuestController

  before_filter :set_ruby_version_header
  layout :layout_by_resource

  # RESCUES ------------------------------------------------------------------

  rescue_from User::NotAuthorised do
    render file: Rails.root.join('public/404.html'),
           status: :not_found, layout: false
  end

  # FILTERS ------------------------------------------------------------------

  ##########
  protected
  ##########

  # Set the layout to Backstage's for all Devise views
  def layout_by_resource
    devise_controller? ? 'backstage' : 'application'
  end

  # A temporary filter which sends the full Ruby version as an HTTP header.
  # I'm using this to test the Ruby 1.9.3-p125 update and it will be removed
  # again shortly.
  #
  def set_ruby_version_header
    require 'rbconfig'

    headers['X-Ruby-Version'] =
      %w( RUBY_PROGRAM_VERSION PATCHLEVEL ).map do |key|
        RbConfig::CONFIG[key]
      end.join('-p')
  end

end
