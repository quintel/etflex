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

    # Wait until the page has loaded.
    page.should have_css('#left-inputs')

    page.status_code.should eql(200)
  end

  # --------------------------------------------------------------------------

end
