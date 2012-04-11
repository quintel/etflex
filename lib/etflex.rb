require 'etflex/client_controller'
require 'etflex/client_responder'
require 'etflex/concatenated_attributes'
require 'etflex/etengine_proxy'
require 'etflex/guest_controller'
require 'etflex/locale_controller'
require 'etflex/prop_analyzer'
require 'etflex/pusher_controller'

module ETFlex

  # The ETFlex configuration.
  def self.config
    @config ||= Hashie::Mash.new(
      YAML.load_file(Rails.root.join('config/etflex.yml'))[ Rails.env ])
  rescue Errno::ENOENT => e
    raise 'You need to copy config/etflex.sample.yml to config/etflex.yml!'
  end
end
