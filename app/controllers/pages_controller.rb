class PagesController < ApplicationController
  helper ScenesHelper

  # The root page.
  #
  # GET /
  #
  def root
    @scenes = Scene.limit(10)

    # We need to select twice as many scenarios as are actually displayed; if
    # a scenario currently in the top five is demoted, we need the next
    # highest so that it can be promoted in the UI. So, twice as many allows
    # all of the top five to be demoted without the UI crapping out.
    #
    # In the real world, (number_shown) + 2 should be enough...
    #
    @high_scenarios = Scenario.last_week.by_score.limit(20)
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
