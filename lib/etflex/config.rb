module ETFlex
  # The ETFlex configuration.
  def self.config
    @config ||= Hashie::Mash.new(Rails.application.config_for(:etflex))
  rescue Errno::ENOENT => e
    raise 'You need to copy config/etflex.sample.yml to config/etflex.yml!'
  end
end
