module ETFlex
  # Given the behaviour of a prop, extracts useful information about that prop
  # from the CoffeeScript source for use in the Rails application.
  #
  class PropAnalyzer

    # Contains a Ruby version of the prop_map configuration. Will be empty
    # until the first PropAnalyzer is initialized.
    MAP = {}

    # Maps information about a single CoffeeScript prop.
    Mapping = Struct.new(:path, :behaviour)

    # Populates the MAP constant the first time a PropAnalyzer is created.
    def self.populate_map!
      config = Rails.root.join('config/prop_map.yml')

      YAML.load_file(config).each do |behaviour, (path)|
        path = Rails.root.join("client/views/props/#{ path }.coffee")
        MAP[behaviour] = Mapping.new(path, behaviour).freeze
      end

      MAP.freeze
    end

    # ------------------------------------------------------------------------

    attr_reader :mapping

    # Creates a new PropAnalyzer.
    #
    # prop - The prop whose CoffeeScript source you want to analyze.
    #
    def initialize(prop)
      self.class.populate_map! if MAP.empty?

      if (@mapping = MAP[ prop.behaviour ]).blank?
        raise "No such prop behaviour in the map: #{ prop.behaviour }"
      end
    end

    # Returns an array containing a list of the queries used by the prop. Each
    # query is a string representing the query key.
    #
    def queries
      match = File.read(@mapping.path).match(/@queries: (?<queries>[^\]]+)/)

      if match.blank? then [] else
        match[:queries].gsub(/\[\s*/, '').split(/\n|,/).map do |query|
          query.strip.gsub(/^['"](.+?)['"]$/, '\1').presence
        end.compact
      end
    end

  end
end # ETFlex
