if ETFlex.config.pusher && ETFlex.config.pusher[:app_id].present?
  Pusher.app_id = ETFlex.config.pusher[:app_id]
  Pusher.key    = ETFlex.config.pusher[:key]
  Pusher.secret = ETFlex.config.pusher[:secret]
end
