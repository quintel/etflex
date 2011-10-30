require 'tilt'

module ETFlex::Tilt
  # A customised version of the CoffeeScript template which will handle all
  # CoffeeScript normally, except those in /client which will be created as
  # modules for use with Stitch.
  #
  class StitchCS < Tilt::CoffeeScriptTemplate
    self.default_mime_type = 'application/javascript'

    # Compiles the CoffeeScript source.
    #
    # If the source file is in the /client directory, it will be compiled as a
    # CommonJS module for use with Stitch.
    #
    def evaluate(scope, locals, &block)
      if scope.root_path.split('/').last == 'client'
        @output ||=
          <<-EOF.gsub(/^ {12}/, '')
            require.define({ '#{ scope.logical_path }': function(exports, require, module) {
            #{ CoffeeScript.compile(data, bare: true) }
            }});
          EOF
      else
        # Not in /client, just compile a normal CoffeeScript.
        super
      end
    end

  end # StitchCS
end # ETFlex::Tilt
