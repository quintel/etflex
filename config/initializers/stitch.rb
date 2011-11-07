if ETFlex::Application.config.assets.compile
  require 'tilt/stitch_cs'
  require 'tilt/stitch_eco'

  ETFlex::Application.assets.register_engine '.coffee', ETFlex::Tilt::StitchCS
  ETFlex::Application.assets.register_engine '.eco',    ETFlex::Tilt::StitchEco
end
