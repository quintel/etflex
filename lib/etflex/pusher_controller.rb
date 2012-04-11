module ETFlex
  # Mixes in functionality to controllers which need to send data to the
  # Pusher service, which is then picked up by JS clients.
  #
  module PusherController

    #######
    private
    #######

    # Sends a message to Pusher using the default channel (which is "etflex-"
    # suffixed with the current Rails environment).
    #
    # event - The name of the event to be triggered on Pusher (for example
    #         "scenario.created", etc).
    #
    # data  - An optional hash of extra data to be sent. Also send by Pusher
    #         to connected clients.
    #
    def pusher(event, data = nil)
      if ETFlex.config.realtime
        Pusher["etflex-#{ Rails.env }"].trigger! event, data
      end
    end

  end # PusherController
end # ETFlex
