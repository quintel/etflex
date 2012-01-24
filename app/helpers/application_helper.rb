module ApplicationHelper
  # The options hash used to configure the Backbone client. Provides the
  # locale, API url, etc.
  #
  # Returns a string with the JSON.
  #
  def client_options
    rendered_user = if respond_to?(:user_signed_in?) and user_signed_in?
      render partial: 'embeds/user', formats: [:json],
        locals: { user: current_user }
    end

    { locale:   I18n.locale,
      api:      ETFlex.config.api_url,
      user:     rendered_user ? JSON.parse(rendered_user) : nil
    }.to_json
  end
end
