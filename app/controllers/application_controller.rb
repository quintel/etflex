class ApplicationController < ActionController::Base
  protect_from_forgery

  include ETFlex::GuestController
  include ETFlex::LocaleController
  include ETFlex::PusherController

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

end
