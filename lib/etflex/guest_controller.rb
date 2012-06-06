module ETFlex
  # Mixes in functionality to controllers to provide helper methods for
  # dealing with guest sessions.
  #
  module GuestController
    extend ActiveSupport::Concern

    included do
      before_filter :handle_guest_id
      helper_method :guest_user
      helper_method :current_or_guest_user
    end

    #######
    private
    #######

    # Guests have a unique ID set so that they may save their scenarios.
    #
    # This method handles migration of the old :guest_id cookie to the newer
    # format, and removes the :guest cookie if the user is signed in to a
    # proper user account.
    #
    def handle_guest_id
      if cookies[:guest_id]
        # Convert to the new guest cookie format.
        Guest.new(cookies.signed[:guest_id]).save(cookies)
        cookies.delete(:guest_id)
      end

      if user_signed_in? and cookies[:guest]
        cookies.delete :guest
      end
    end

    # Returns the Guest instance for the current user. Will return nil if the
    # user is signed into a registered account.
    #
    def guest_user
      @_guest ||= Guest.from_cookies(cookies) unless user_signed_in?
    end

    # Returns the currently signed in user, or the Guest instance if the user
    # is not signed in.
    #
    def current_or_guest_user
      if user_signed_in? then current_user else guest_user end
    end

    # Removes all stored settings about the guest so that a sebsequent request
    # is assigned a new guest ID.
    #
    def reset_guest!
      original_locale = session[:locale]

      reset_session
      session[:locale] = original_locale

      cookies.delete :guest
      @_guest = nil
    end

  end # GuestController
end # ETFlex
