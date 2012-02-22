module ETFlex
  # Mixes in functionality common to controllers which render the Backbone
  # client by default (which should be the vast majority of controllers in
  # ETFlex.
  #
  module ClientController
    extend ActiveSupport::Concern

    # Sets the typical REST actions so that create, edit and destroy actions
    # are JSON-only.
    #
    included do
      before_filter :restrict_html_to_get

      layout 'client'

      respond_to :html, except: [ :create, :update, :destroy ]
      respond_to :json
    end

    # Used as a before_filter in ClientControllers and forcefully denies HTML
    # requests from issuing anything except a GET. Everything else must use
    # JSON.
    #
    def restrict_html_to_get
      head 406 unless request.get? or request.format.json?
    end

    # Returns a hash which may be used in conjunction with `render` so that
    # you may simply
    #
    #   render client
    #
    # Pass extra rendering options to `client` has a hash, like so:
    #
    #   render client(meaning: 42)
    #
    def client(options = nil)
      if options.nil? then { template: 'application/client' } else
        options.merge template: 'application/client'
      end
    end

    module ClassMethods
      # Use the ClientResponder so that the Backbone client is rendered for
      # HTML requests.
      #
      def responder
        ETFlex::ClientResponder
      end

      # Hide the public "client" method used with render client, and by the
      # ClientResponder.
      #
      def hide_actions
        super.push :client
      end
    end # ClassMethods

  end # ClientController
end # ETFlex
