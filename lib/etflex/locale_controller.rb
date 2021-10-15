module ETFlex
  # Mixes in functionality to controllers so that the locale is set
  # appropriately for the user.
  #
  # Sets language based on the following order:
  #
  #   * The value of a "locale" parameter present in GET or POST data.
  #   * The existing session[:locale] value.
  #   * Infers the correct language from the Accept-Language header.
  #
  module LocaleController
    extend ActiveSupport::Concern

    included { before_action :set_locale }

    # Set the languages for which we have translations.
    AVAILABLE_LOCALES = %w( en nl )

    #######
    private
    #######

    # Sets the language to be used for the user; permits setting it through the
    # +locale+ query param.
    #
    def set_locale
      if params[:locale].present?
        # Allow changing the locale by passing a locale parameter when making
        # the request.
        locale = params.delete(:locale).to_s

        # A temporary workaround for Backbone including ?locale=... in its
        # routes; we should probably add /:locale/... instead, or a single
        # actions which changes the locale to avoid having to manually remove
        # the locale param in every Backbone action.
        locale.gsub! /\.json/, ''

        locale = I18n.default_locale unless AVAILABLE_LOCALES.include?(locale)

        session[:locale] = locale

      elsif session[:locale].blank?
        # No locale set yet; first visit. Use the Accept-Language header to
        # infer what they want.
        session[:locale] =
          http_accept_language.compatible_language_from(AVAILABLE_LOCALES)
      end

      I18n.locale = session[:locale]
    end

    def alternative_locales
      AVAILABLE_LOCALES.reject{ |locale| locale == I18n.locale.to_s }
    end

  end # LocaleController
end # ETFlex
