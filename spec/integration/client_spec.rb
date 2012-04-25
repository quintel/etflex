require 'spec_helper'

describe 'The Backbone client' do

  let(:scene) { create :scene }

  # --------------------------------------------------------------------------

  specify 'Should load in client mode at the root path' do
    visit ''

    # English by default.
    page.should have_css('script', text: "boot(window,")

    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English by default' do
    # TODO This should probably be Dutch, not English?

    visit "/scenes/#{ scene.id }"

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window,")

    # English by default.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with Accept-Language: en' do
    page.driver.header 'Accept-Language', 'en'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with Accept-Language: en-GB' do
    page.driver.header 'Accept-Language', 'en-GB'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with Accept-Language: en-US' do
    page.driver.header 'Accept-Language', 'en-US'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in Dutch with Accept-Language: nl' do
    page.driver.header 'Accept-Language', 'nl'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"nl"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in Dutch with Accept-Language: nl-NL' do
    page.driver.header 'Accept-Language', 'nl-NL'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"nl"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in Dutch with Accept-Language: nl-BE' do
    page.driver.header 'Accept-Language', 'nl-BE'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"nl"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with Accept-Language: de' do
    page.driver.header 'Accept-Language', 'de'

    visit "/scenes/#{ scene.id }"

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with ?locale=en' do
    visit "/scenes/#{ scene.id }?locale=en"

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window")

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with ?locale=en.json' do
    # Tests an odd error witih Backbone.

    visit "/scenes/#{ scene.id }?locale=en.json"

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window")

    # English when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in Dutch with ?locale=nl' do
    visit "/scenes/#{ scene.id }?locale=nl"

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window")

    # Dutch when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"nl"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should load in English with ?locale=de' do
    visit "/scenes/#{ scene.id }?locale=de"

    # Should boot in "full" mode.
    page.should have_css('script', text: "boot(window")

    # Dutch when specified in the URL.
    script = find('script', text: "boot(window,")
    script.text.should match(/"locale":"en"/)
  end

  # --------------------------------------------------------------------------

  specify 'Should not be in conference mode by default' do
    visit ''

    # English by default.
    page.should have_css('script', text: "boot(window,")

    script = find('script', text: "boot(window,")
    script.text.should match(/"conference":false/)
  end

end
