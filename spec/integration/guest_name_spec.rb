require 'spec_helper'

feature 'Requesting the visitors name', js: true do
  let!(:scene) { create :scene_with_inputs, name: 'Balancing Supply and Demand' }

  # --------------------------------------------------------------------------

  scenario 'As a guest with no name set; entering a name' do
    visit "/scenes/#{ scene.id }"

    # Guest should be asked for their name.
    page.should have_css('.high-score-request')

    # Assert that the correct name request box is shown (not the "you got a
    # high score!" box).
    page.should have_css('.high-score-request h3', content: 'Welcome')

    fill_in 'Your name', with: 'Jeff Winger'
    click_button 'Save'

    wait_for_xhr

    # Reload the page and make sure the user name is set.
    visit "/scenes/#{ scene.id }"

    script = find('script', text: "boot(window,")
    script.text.should match(/"name":"Jeff Winger"/)

    # Name should not be requested again.
    page.should_not have_css('.high-score-request')
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest with no name set; remaining anonymous' do
    visit "/scenes/#{ scene.id }"

    # Guest should be asked for their name.
    page.should have_css('.high-score-request')

    # Assert that the correct name request box is shown (not the "you got a
    # high score!" box).
    page.should have_css('.high-score-request h3', content: 'Welcome')

    fill_in 'Your name', with: ''
    click_button 'Save'

    wait_for_xhr

    # Reload the page and make sure the user name is set.
    visit "/scenes/#{ scene.id }"

    script = find('script', text: "boot(window,")
    script.text.should_not match(/"name":/)

    pending 'Pending persistent anonymity'

    # Name should not be requested again.
    page.should_not have_css('.high-score-request')
  end

  # --------------------------------------------------------------------------

  scenario 'As a user with no name set; entering a name' do
    sign_in create(:user, name: nil)

    visit "/scenes/#{ scene.id }"

    # Guest should be asked for their name.
    page.should have_css('.high-score-request')

    # Assert that the correct name request box is shown (not the "you got a
    # high score!" box).
    page.should have_css('.high-score-request h3', content: 'Welcome')

    fill_in 'Your name', with: 'Britta Perry'
    click_button 'Save'

    wait_for_xhr

    # Reload the page and make sure the user name is set.
    visit "/scenes/#{ scene.id }"

    script = find('script', text: "boot(window,")
    script.text.should match(/"name":"Britta Perry"/)

    # Name should not be requested again.
    page.should_not have_css('.high-score-request')
  end

  # --------------------------------------------------------------------------

  scenario 'As a user with no name set; remaining anonymous' do
    sign_in create(:user, name: nil)

    visit "/scenes/#{ scene.id }"

    # Guest should be asked for their name.
    page.should have_css('.high-score-request')

    # Assert that the correct name request box is shown (not the "you got a
    # high score!" box).
    page.should have_css('.high-score-request h3', content: 'Welcome')

    fill_in 'Your name', with: ''
    click_button 'Save'

    wait_for_xhr

    # Reload the page and make sure the user name is set.
    visit "/scenes/#{ scene.id }"

    script = find('script', text: "boot(window,")
    script.text.should_not match(/"name":/)

    pending 'Pending persistent anonymity'

    # Name should not be requested again.
    page.should_not have_css('.high-score-request')
  end

end
