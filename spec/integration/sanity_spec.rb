require 'spec_helper'

describe 'The "Sanity" test page' do

  # --------------------------------------------------------------------------

  specify 'Viewing the test page',  js: true do
    visit '/sanity'

    page.should have_content('Hello from Eco and Backbone!')
  end

  # --------------------------------------------------------------------------

  specify 'Clicking the ETlite link', js: true do
    visit '/sanity'

    click_link 'the ETlite page'

    page.should have_css('h2', 'Savings')
    page.should have_css('h2', 'Production')
  end

  # --------------------------------------------------------------------------

end
