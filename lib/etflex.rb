require 'etflex/client_controller'
require 'etflex/client_responder'

module ETFlex
  # A simpler way to access the ETFlex configuration.
  def self.config
    Application.config.etflex
  end
end
