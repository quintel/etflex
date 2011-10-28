require 'tilt'

module ETFlex::Tilt
  class StitchCS < Tilt::Template
    self.default_mime_type = 'application/javascript'

     def self.engine_initialized?
      defined? ::CoffeeScript
    end

    def initialize_engine
      require_template_library 'coffee_script'
    end

    def prepare
      options[:bare] = true
    end

    def evaluate(scope, locals, &block)
      @output ||= <<-EOF.gsub(/^ {8}/, '')
        require.define({ '#{ module_name(scope) }': function(exports, require, module) {
          #{ CoffeeScript.compile(data, options) }
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
