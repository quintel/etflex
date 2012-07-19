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
    script.text.should match(/"name":null/)

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
    script.text.should match(/"name":null/)

    # Name should not be requested again.
    page.should_not have_css('.high-score-request')
  end

  # --------------------------------------------------------------------------

  scenario 'Creating a fresh guest (for conferences)', conference: true do
    # Start a guest session.
    visit "/scenes/#{ scene.id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    user_id = page.evaluate_script 'require("app").user.id'

    # Dismiss the guest name dialog so that we can assert that creating a new
    # guest asks for the name again.

    fill_in 'Your name', with: 'Britta Perry'
    click_button 'Save'

    wait_for_xhr

    # Visit the fresher page.
    # visit "/scenes/#{ scene.id }/fresh"

    visit ''
    click_link 'Create your own future'

    page.evaluate_script('require("app").user.id').should_not eql(user_id)

    # Name should be requested again.
    page.should have_css('.high-score-request')

    fill_in 'Your name', with: 'Troy Barnes'
    click_button 'Save'

    wait_for_xhr

    # Assert that guest names aren't overwritten.

    scenarios = Scenario.all
    scenarios.should have(2).scenarios

    scenarios.first.guest_name.should eql('Britta Perry')
    scenarios.last.guest_name.should  eql('Troy Barnes')
  end

  # --------------------------------------------------------------------------

  scenario 'Retaining locale when creating a fresh guest', conference: true do
    # Start a guest session.
    visit ''
    click_link 'Nederlandse versie'

    visit '/scenes/1'

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Visit the fresher page.
    visit "/scenes/#{ scene.id }/fresh"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    visit ''

    page.should have_content('English version')
    page.should_not have_content('Nederlandse versie')
  end

  # --------------------------------------------------------------------------

  scenario 'Setting name as a guest, then registering' do
    visit "/scenes/#{ scene.id }"

    fill_in 'Your name', with: 'Jeff Winger'
    click_button 'Save'

    wait_for_xhr

    click_link 'Sign in'
    click_link 'Sign up'

    fill_in 'E-mail address',   with: 'test@example.com'
    fill_in 'Password',         with: 'testtest'
    fill_in 'Confirm password', with: 'testtest'

    click_button 'Sign up'

    click_link 'Create your own future'

    page.should have_css('.scene-nav', text: 'Account')

    # User should be asked for their name (again).
    page.should have_css('.high-score-request')
  end

end
