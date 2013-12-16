module ETFlex
  # The ETFlex configuration.
  def self.config
    @config ||= Hashie::Mash.new(
      YAML.load_file(Rails.root.join('config/etflex.yml'))[ Rails.env ])
  rescue Errno::ENOENT => e
    raise 'You need to copy config/etflex.sample.yml to config/etflex.yml!'
  end
end
