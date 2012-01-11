module ApplicationHelper
  # The options hash used to configure the Backbone client. Provides the
  # locale, API url, etc.
  #
  # Returns a string with the JSON.
  #
  def client_options
    { locale:   I18n.locale,
      api:      ETFlex.config.api_url,
      signedIn: user_signed_in?
    }.to_json
  end
end
