module ETFlex
  class QueryExtrema

    # Creates a new QueryExtrema which represents the minimum and maximum
    # values of a query for a scene prop in a given country.
    #
    def initialize(data)
      @data = data || Hash.new
    end

    # Returns the minimum and maximum values for a query in a given region,
    # where the region is identified by it's two-character code. nil will be
    # returned if there is no extrema for the region, or the query.
    #
    # For example:
    #
    #   extrema.for_query 'query_key', 'uk'
    #   # => [ 8, 256 ]
    #
    def for_query(query, country)
      if for_country = @data[country.to_s]
        for_country[query.to_s]
      end
    end

    # Returns a copy of the original data, suitable for serialization as JSON
    # for sending to the client.
    #
    def as_json
      @data.dup
    end

  end # QueryExtrema
end
