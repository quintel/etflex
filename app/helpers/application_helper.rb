module ApplicationHelper
  # The options hash used to configure the Backbone client. Provides the
  # locale, API url, etc.
  #
  # Returns a string with the JSON.
  #
  def client_options
    user_partial  = if user_signed_in? then 'user' else 'guest' end
    rendered_user = render partial: "embeds/#{user_partial}",
      formats: [:json], locals: { user: current_or_guest_user }

    { locale:   I18n.locale,
      api:      ETFlex.config.api_url,
      env:      Rails.env,
      user:     JSON.parse(rendered_user)
    }.to_json
  end

  def unsupported_browser?
    not ETFlex.config.supported_browsers.include? user_agent
  end

  def user_agent
    user_agent = request.env['HTTP_USER_AGENT']
    return 'android' if user_agent =~ /Android/
    return 'ipad' if user_agent =~ /iPad/    
    return 'iphone' if user_agent =~ /iPhone/    
    return 'firefox' if user_agent =~ /Firefox/
    return 'chrome' if user_agent =~ /Chrome/
    return 'safari' if user_agent =~ /Safari/
    return 'opera' if user_agent =~ /Opera/
    return 'ie9' if user_agent =~ /MSIE 9/
    return 'ie8' if user_agent =~ /MSIE 8/
    return 'ie7' if user_agent =~ /MSIE 7/
    return 'ie6' if user_agent =~ /MSIE 6/
  end

end
