module ETFlex
  # A custom ActionController responder which, instead of trying to render a
  # template specific to the action, will render the HTML necessary to set up
  # the Backbone client, on the assumption that Backbone will handle setting
  # up the page correctly.
  #
  # For example, visiting /scenes/1 using the default responder would render
  # the scenes/show template. Instead this responder will always render the
  # HTML for the Backbone client.
  #
  class ClientResponder < ActionController::Responder

    # HTML format renders the Backbone client, not a template.
    #
    def to_html
      @controller.render @controller.__send__ :client
    end

  end # ClientResponder
end # ETFlex
