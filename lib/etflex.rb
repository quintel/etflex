require 'etflex/client_controller'
require 'etflex/client_responder'
require 'etflex/concatenated_attributes'

module ETFlex
  # A simpler way to access the ETFlex configuration.
  def self.config
    Application.config.etflex
  end
end
