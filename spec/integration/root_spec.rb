require 'rails_helper'

feature 'Viewing the root page' do
  include ETFlex::Spec::SignIn

  before(:all) do
    @scene = create :detailed_scene
  end

  def root_link_matcher(link)
    have_link(href: link)
  end

  def have_scene_link(scene)
    root_link_matcher("/scenes/#{scene.id}")
  end

  def have_fresh_scene_link(scene)
    root_link_matcher("/scenes/#{scene.id}/fresh")
  end

  def have_scenario_link(scene, scenario = nil)
    if scenario.nil?
      root_link_matcher("/scenes/#{scene.id}/with")
    else
      root_link_matcher("/scenes/#{scene.id}/with/#{scenario.session_id}")
    end
  end

  # Capybara::Selenium has no status_code support
  def have_status_code_ok
    have_no_content("The page you were looking for doesn't exist") && # 404
      have_no_content('The change you wanted was rejected') && # 422
      have_no_content("We're sorry, but something went wrong") # 500
  end


  # --------------------------------------------------------------------------

  scenario 'as a guest who has not attempted a scene', js: true do
    visit ''

    expect(page).to have_status_code_ok

    page.should have_scene_link(@scene)
    page.should_not have_scenario_link(@scene)
  end

  # --------------------------------------------------------------------------

  scenario 'as a guest who has attempted a scene', js: true do
    visit "/scenes/#{ @scene.id }"

    # Wait until the page has loaded.
    expect(page).to have_css('#left-inputs', wait: 30)
    sleep 0.2

    # Remove tour overlay
    find('.overlay-message .hide').click

    find('#logo').click

    expect(page).to have_status_code_ok

    page.should have_scene_link(@scene)
    page.should have_scenario_link(@scene, Scenario.last)
  end

  # --------------------------------------------------------------------------

  scenario 'as a guest who has attempted a scene (conference mode)', conference: true, js: true do
    visit "/scenes/#{ @scene.id }"

    # Wait until the page has loaded.
    page.should have_css('#left-inputs')
    sleep 0.2

    # Remove tour overlay
    find('.overlay-message .hide').click

    find('#logo').click

    expect(page).to have_status_code_ok

    page.should have_fresh_scene_link(@scene)
    page.should have_scenario_link(@scene, Scenario.last)
  end

  # --------------------------------------------------------------------------

  scenario 'as a user who has not attempted a scene', sign_in: true, js: true do
    sign_in create(:user)

    visit ''

    expect(page).to have_status_code_ok

    page.should have_scene_link(@scene)
    page.should_not have_scenario_link(@scene)
  end

  # --------------------------------------------------------------------------

  scenario 'as a user who has attempted a scene', sign_in: true, js: true do
    sign_in create(:user)
    scene = create :detailed_scene
    visit "/scenes/#{scene.id}"

    # Wait until the page has loaded.
    page.should have_css('#left-inputs')
    sleep 0.2

    # Remove tour overlay
    find('.overlay-message .hide').click

    find('#logo').click

    expect(page).to have_status_code_ok

    page.should have_scene_link(scene)
    page.should have_scenario_link(scene, Scenario.last)
  end

end
