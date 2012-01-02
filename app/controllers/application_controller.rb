class ApplicationController < ActionController::Base
  protect_from_forgery

  # RESCUES ------------------------------------------------------------------

  rescue_from User::NotAuthorised do
    render file: Rails.root.join('public/404.html'),
           status: :not_found, layout: false
  end

  # FILTERS ------------------------------------------------------------------

  #######
  private
  #######

  before_filter :set_locale 
  layout :layout_by_resource

  # Sets the language to be used for the user; permits setting it through the
  # +locale+ query param.
  #
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end
  
  ##########
  protected
  ##########

  # Set the layout to Backstage's for all Devise views
  #
  #
  def layout_by_resource
    devise_controller? ? "backstage" : nil
  end


end
