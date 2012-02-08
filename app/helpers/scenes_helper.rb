module ScenesHelper
  # Returns the information for an input, based on the currently set locale.
  #
  # input - The input whose information is to be retrieved.
  #
  def information_for_input(input)
    information =
      if I18n.locale == :nl
        input.information_nl
      else
        input.information_en
      end.presence

    if information.nil? then nil else
      markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::SmartyHTML.new(
          filter_html:    true,
          no_styles:      true,
          safe_link_only: true,
          xhtml:          true
        ),

        auto_link:           true,
        space_after_headers: true,
        no_intra_emphasis:   true,
        superscript:         true
      )

      markdown.render(information)
    end
  end

  # SCENARIOS ----------------------------------------------------------------

  # Returns all the scenarios for a scene which belong to the current user of
  # the application.
  #
  # scene - The scene to which the returned scenarios should belong.
  #
  def scenarios_for_current_user(scene)
    scene.scenarios.for_user(current_or_guest_user).recent
  end

  # Returns all the scenarios for a scene which belong to people other than
  # the current user of the application
  #
  # scene - The scene to which the returned scenarios should belong.
  #
  def scenarios_for_other_users(scene)
    scene.scenarios.for_users_other_than(current_or_guest_user).by_score
  end

  # Given a scenario, returns it's score. Doesn't blow up if the scenario has
  # no score available.
  #
  # Returns a string.
  #
  # scenario - The scenario whose score is to be returned.
  #
  def scenario_score(scenario)
    if scenario.score.blank? then '???' else
      scenario.score.round.to_s
    end
  end

  # Returns when a scenario was last modified by the user, nicely formatted
  # using time_ago_in_words.
  #
  # Returns a string.
  #
  # scenario - The scenario whose modification time is to be returned.
  #
  def scenario_age(scenario)
    [ time_ago_in_words(scenario.updated_at || scenario.created_at),
      I18n.t('words.ago') ].join(' ')
  end
end
