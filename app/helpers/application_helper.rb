module ApplicationHelper
  # Public: The configuration hash for the Backbone client.
  #
  # Returns a string representation of the JSON.
  def client_options
    user_partial  = if user_signed_in? then 'user' else 'guest' end
    rendered_user = render partial: "embeds/#{user_partial}",
      formats: [:json], locals: { user: current_or_guest_user }

    { locale:   I18n.locale,
      api:      ETFlex.config.api_url,
      env:      Rails.env,
      user:     JSON.parse(rendered_user),
      realtime: ETFlex.config.realtime
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
  # yet fully supported by ET-Flex.
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
