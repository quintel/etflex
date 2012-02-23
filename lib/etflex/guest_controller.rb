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
    def handle_guest_id
      if user_signed_in? and cookies[:guest_id]
        cookies.delete :guest_id
      elsif ! user_signed_in? and cookies[:guest_id].blank?
        cookies.permanent.signed[:guest_id] = {
          httponly: true, value: SecureRandom.uuid }
      end
    end

    # Returns the Guest instance for the current user. Will return nil if the
    # user is signed into a registered account.
    #
    def guest_user
      @_guest ||= Guest.new cookies.signed[:guest_id] unless user_signed_in?
    end

    # Returns the currently signed in user, or the Guest instance if the user
    # is not signed in.
    #
    def current_or_guest_user
      if user_signed_in? then current_user else guest_user end
    end

  end # GuestController
end # ETFlex
