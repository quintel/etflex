require 'tilt'

module ETFlex::Tilt
  # A customised version of the Eco template which will handle all Eco
  # templates normally, except those in /client which will be created as
  # modules for use with Stitch.
  #
  class StitchEco < Sprockets::EcoTemplate
    self.default_mime_type = 'application/javascript'

    # Compiles the Eco source.
    #
    # If the source file is in the /client directory, it will be compiled as
    # a CommonJS module for use with Stitch.
    #
    def evaluate(scope, locals, &block)
      if scope.root_path.split('/').last == 'client'
        @output ||= <<-EOF.gsub(/^ {10}/, '')
          require.define({ '#{ scope.logical_path }': function(e, r, m) {
            m.exports = #{ Eco.compile(data) }
          }});
        EOF
      else
        super
      end
    end

  end # StitchEco
end # ETFlex::Tilt
