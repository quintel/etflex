class PagesController < ApplicationController
  helper ScenesHelper

  # Supported browser page breaks otherwise in non-pushState browsers if we
  # use the application layout.
  layout false, only: 'supported_browsers'

  # The root page.
  #
  # GET /
  #
  def root
    @alternative_locales = alternative_locales
    @scenes = Scene.limit(10)

    @high_scenarios = Scenario.high_scores_since 7.days.ago
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

end
