module ETFlex
  # Mixes in functionality so that we may disable display of the scenario score
  # by including "score=off", "score=false", or "score=hide" as a query
  # parameter. Any other value will result in the score being displayed.
  #
  # Disabling scores by this mechanism will hide the score "podium" prop, and
  # the high score list.
  #
  # Note that the high score list will never be displayed, regardless of the
  # "score" parameter if the etflex.yml file contains "high_scores: false".
  #
  # Use "before_filter :show_hide_scores" to enable the feature on the controller
  # or action.
  module ScoreController
    extend ActiveSupport::Concern

    included { helper_method :scores_enabled? }

    # Values which correspond with turning the score off. Anything else will
    # turn the scores on.
    SCORE_OFF_VALUES = %w( off no false hide )

    # Public: Returns if the high score podium, and high score list, should be
    # displayed to the user.
    def scores_enabled?
      session[:show_scores] != false
    end

    #######
    private
    #######

    # Shows or hides scores depending on the +score+ query param.
    def enable_or_disable_scores
      if params[:scores].present?
        session[:show_scores] = ! SCORE_OFF_VALUES.include?(params[:scores])
      end
    end

  end # ScoreController
end # ETFlex
