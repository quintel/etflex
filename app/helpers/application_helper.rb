module ApplicationHelper
  # Public: Renders the scores depending on what is passed
  #
  # Returns a string with the JSON representation
  def high_scores_pusher_event(high_scores)
    # If it's a hash, we're going to render high scores for all
    # scenes
    if high_scores.is_a? Hash
      result = {}
      high_scores.each do |scene_id, scores|
        result[scene_id] = high_scores_pusher_event(scores)
      end

      result
    # If it's an Array, we're rendering a collection of high scores
    # for a scene
    elsif high_scores.is_a? Array
      high_scores.map(&:to_pusher_event)
    end
  end


  # Public: The configuration hash for the Backbone client.
  #
  # Returns a string representation of the JSON.
  def client_options
    user_partial  = if user_signed_in? then 'user' else 'guest' end
    rendered_user = render partial: "embeds/#{user_partial}",
      formats: [:json], locals: { user: current_or_guest_user }

    { locale:     I18n.locale,
      api:        ETFlex.config.api_url,
      env:        Rails.env,
      user:       JSON.parse(rendered_user),
      pusher_key: ETFlex.config[:key],
      conference: ETFlex.config.conference,
      offline:    ETFlex.config.offline,
      etm_url:    ETFlex.config.etm_url,
      scores:     scores_enabled?
    }.to_json
  end

  # Public: Returns if the user browser is one we support.
  #
  # Unsupported browsers may still use the site, but will have a message
  # displayed.
  #
  # Returns true or false.
  def supported_browser?
    ETFlex.config.supported_browsers.include? user_agent
  end

  # Public: A simplified version of the browser UserAgent.
  #
  # Some devices which may have the same OS/browser versions are
  # differentiated (e.g. iPhone, iPad) since their lower resolutions are not
  # yet fully supported by ETflex.
  #
  # Returns a string.
  def user_agent
    case request.env['HTTP_USER_AGENT']
      when /MSIE (\d+)/ then "ie#{ $1 }"
      when /Chrome/     then 'chrome'
      when /Firefox/    then 'firefox'
      when /iPhone/     then 'iphone'
      when /iPad/       then 'ipad'
      when /Android/    then 'android'
      when /Safari/     then 'safari'
      when /Opera/      then 'opera'
      else                   'unknown'
    end
  end

end
