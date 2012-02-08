module ETFlex
  # Given the behaviour of a prop, extracts useful information about that prop
  # from the CoffeeScript source for use in the Rails application.
  #
  class PropAnalyzer

    # Maps information about a single CoffeeScript prop.
    Mapping = Struct.new(:path, :key, :behaviour)

    MAP =
      YAML.load_file(Rails.root.join('config/prop_map.yml')).
            each_with_object({}) do |(behaviour, info), map|

        path = Rails.root.join("client/views/props/#{ info[0] }.coffee")
        map[behaviour] = Mapping.new(path, info[1], behaviour).freeze
      end.freeze

    # ------------------------------------------------------------------------

    attr_reader :mapping

    # Creates a new PropAnalyzer.
    #
    # prop - The prop whose CoffeeScript source you want to analyze.
    #
    def initialize(prop)
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
