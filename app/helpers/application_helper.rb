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
end
