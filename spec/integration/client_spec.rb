require 'spec_helper'

describe 'The Backbone client' do

  before do
    @scene = create :scene
  end

  # --------------------------------------------------------------------------

  specify 'Should load in minimal mode at the root path' do
    visit '/'

    # English by default.
    page.should     have_css('script', text: "minimal(window,")
    page.should_not have_css('script', text: "boot(window,")

    script = find('script', text: "minimal(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English by default' do
    # TODO This should probably be Dutch, not English?

    visit "/scenes/#{ @scene.id }"

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window,")

    # English by default.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with ?locale=en' do
    visit "/scenes/#{ @scene.id }?locale=en"

    # Loading message should be shown.
    page.should have_css('.loading', text: 'Loading')

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window")

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in Dutch with ?locale=nl' do
    visit "/scenes/#{ @scene.id }?locale=nl"

    # Loading message should be shown.
    page.should have_css('.loading', text: 'Bezig met laden')

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window")

    # Dutch when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"nl"/)
  end

  # --------------------------------------------------------------------------

end
