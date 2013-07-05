require 'spec_helper'

feature 'Viewing the root page' do

  background do
    @scene = create :detailed_scene
  end

  def root_link_matcher(link)
    have_css(".go a[href#{ link }]")
  end

  def have_scene_link(scene)
    root_link_matcher("='/scenes/#{ scene.id }'")
  end

  def have_fresh_scene_link(scene)
    root_link_matcher("='/scenes/#{ scene.id }/fresh'")
  end

  def have_scenario_link(scene, scenario = nil)
    if scenario.nil?
      root_link_matcher("^='/scenes/#{ scene.id }/with'")
    else
      root_link_matcher("='/scenes/#{ scene.id }/with/#{ scenario.session_id }'")
    end
  end

  # --------------------------------------------------------------------------

  scenario 'as a guest who has not attempted a scene', js: true do
    visit ''

    page.status_code.should eql(200)

    page.should have_scene_link(@scene)
    page.should_not have_scenario_link(@scene)
  end

  # --------------------------------------------------------------------------

  scenario 'as a guest who has attempted a scene', js: true do
    visit "/scenes/#{ @scene.id }"

    # Wait until the page has loaded.
    page.should have_css('#left-inputs')

    find('#logo').trigger('click')

    page.status_code.should eql(200)

    page.should have_scene_link(@scene)
    page.should have_scenario_link(@scene, Scenario.last)
  end

  # --------------------------------------------------------------------------

  scenario 'as a guest who has attempted a scene (conference mode)', conference: true, js: true do
    visit "/scenes/#{ @scene.id }"

    # Wait until the page has loaded.
    page.should have_css('#left-inputs')

    find('#logo').trigger('click')

    page.status_code.should eql(200)

    page.should have_fresh_scene_link(@scene)
    page.should have_scenario_link(@scene, Scenario.last)
  end

  # --------------------------------------------------------------------------

  scenario 'as a user who has not attempted a scene', js: true do
    sign_in create(:user)

    visit ''

    page.status_code.should eql(200)

    page.should have_scene_link(@scene)
    page.should_not have_scenario_link(@scene)
  end

  # --------------------------------------------------------------------------

  scenario 'as a user who has attempted a scene', js: true do
    user = create :user

    sign_in user
    visit "/scenes/#{ @scene.id }"

    # Wait until the page has loaded.
    page.should have_css('#left-inputs')

    find('#logo').trigger('click')

    page.status_code.should eql(200)

    page.should have_scene_link(@scene)
    page.should have_scenario_link(@scene, Scenario.last)
  end

end
