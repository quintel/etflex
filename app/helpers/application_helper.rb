module ApplicationHelper
  # The options hash used to configure the Backbone client. Provides the
  # locale, API url, etc.
  #
  # Returns a string with the JSON.
  #
  def client_options
    rendered_user = if devise_controller? and user_signed_in?
      render partial: 'embeds/user', user: current_user
    end

    { locale:   I18n.locale,
      api:      ETFlex.config.api_url,
      user:     rendered_user ? JSON.parse(rendered_user) : nil
    }.to_json
  end
end
