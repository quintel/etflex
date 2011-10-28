require 'tilt'
require 'tilt/stitch_cs'

module ETFlex::Tilt
  class StitchEco < Tilt::Template
    self.default_mime_type = 'application/javascript'

    def self.engine_initialized?
      defined? ::Eco
    end

    def initialize_engine
      require_template_library 'eco'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      @output ||= <<-EOF.gsub(/^ {8}/, '')
        require.define({ '#{ module_name(scope) }': function(e, r, m) {
          m.exports = #{ Eco.compile(data) }
        }});
      EOF
    end

    #######
    private
    #######

    def module_name(scope)
      scope.logical_path
    end
  end
end # ETFlex::Tilt
