class PagesController < ApplicationController
  helper  ScenesHelper
  include ETFlex::PusherController

  before_filter :enable_or_disable_scores, only: :root

  # Supported browser page breaks otherwise in non-pushState browsers if we
  # use the application layout.
  layout false, only: 'supported_browsers'

  # The root page.
  #
  # GET /
  #
  def root
    @alternative_locales = alternative_locales

    @scenes           = Scene.all
    @high_scenarios   = Scene.high_scores_since 30.days.ago
  end

  # Changes the user language. The actual change will be handled by
  # ETFlex::LocaleController#set_locale prior to ever arriving at the action.
  #
  # GET /lang/:locale
  #
  def lang
    if path = params[:backto].presence
      # Make sure the first character is a / to prevent possible manipulation
      # of the backto parameter.
      path = '/' unless path.first == ?/
    else
      path = '/'
    end

    redirect_to path
  end

  # Updates current user with the information they have provided. Currently
  # limited to their name only. JSON only.
  #
  # This does not belong here, but Devise complains (loudly) if it is placed
  # in UsersController.
  #
  # PUT /users
  #
  def update_username
    return head(:bad_request) if params[:user].nil?

    name = params[:user][:name].presence

    # Name may be nil if the users wishes to be anonymous.
    if user_signed_in?
      current_user.update_attributes(name: name)
    else
      set_guest_name(name)
    end

    head :no_content

    pusher 'user.updated',
      id:   current_or_guest_user.id,
      name: current_or_guest_user.name
  end

end
