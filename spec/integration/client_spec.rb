require 'spec_helper'

describe 'The Backbone client' do

  # --------------------------------------------------------------------------

  specify 'Should load at the root path' do
    visit '/'

    # Loading message should be shown.
    page.should have_css('.loading', text: 'Loading')

    # English by default.
    page.should have_css('script', text: "boot(window, 'en')")
  end

  # --------------------------------------------------------------------------

  specify 'Should load at /en' do
    pending 'Pending re-addition of language swapping' do
      visit '/en'

      # Loading message should be shown.
      page.should have_css('.loading', text: 'Loading')

      # English when specified in the URL.
      page.should have_css('script', text: "boot(window, 'en')")
    end
  end

  # --------------------------------------------------------------------------

  specify 'Should load at /nl' do
    pending 'Pending re-addition of language swapping' do
      visit '/nl'

      # Loading message should be shown.
      page.should have_css('.loading', text: 'Het laden')

      # Dutch when specified in the URL.
      page.should have_css('script', text: "boot(window, 'nl')")
    end
  end

  # --------------------------------------------------------------------------

end
