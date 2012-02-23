require 'etflex/client_controller'
require 'etflex/client_responder'
require 'etflex/concatenated_attributes'
require 'etflex/etengine_proxy'
require 'etflex/guest_controller'
require 'etflex/locale_controller'
require 'etflex/prop_analyzer'

module ETFlex
  # A simpler way to access the ETFlex configuration.
  def self.config
    Application.config.etflex
  end
end
