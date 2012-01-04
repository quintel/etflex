module ETFlex
  class ETEngineProxy
    class Proxy < Rack::Proxy
      def initialize(*)
        super

        api = URI.parse ETFlex.config.api_url

        @host = api.host.freeze
        @path = api.path.freeze
      end

      def rewrite_env(env)
        env['HTTP_HOST'] = @host
        env['PATH_INFO'] = "#{@path}#{env['PATH_INFO'][4..-1]}"

        env
      end

      def rewrite_response(triplet)
        status, headers, body = triplet

        # Breaks all sorts of things, but I don't yet know what adds it (it
        # certainly isn't present in the ETEngine response).
        headers.delete 'transfer-encoding'

        triplet
      end
    end # Proxy

    def initialize(app)
      @app   = app
      @proxy = Proxy.new
    end

    def call(env)
      if env['PATH_INFO'][0...4] == '/ete'
        @proxy.call(env)
      else
        @app.call(env)
      end
    end

  end # ETEngineProxy
end # ETFlex
