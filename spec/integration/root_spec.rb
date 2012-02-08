require 'spec_helper'

feature 'Viewing the root page' do

  background do
    @scene = create :scene
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, listing the scenes', js: true do
    visit '/root'

    page.status_code.should eql(200)
    page.should have_css("#scene_#{ @scene.id }", content: @scene.name)

    page.should     have_css('#main-nav #nav-user')
    page.should_not have_css('#main-nav #nav-account')
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, listing the scenes', js: true do
    sign_in create(:user)

    visit '/root'

    page.status_code.should eql(200)
    page.should have_css("#scene_#{ @scene.id }", content: @scene.name)

    page.should_not have_css('#main-nav #nav-user')
    page.should     have_css('#main-nav #nav-account')
  end

  # --------------------------------------------------------------------------

  scenario 'As a user who has not attempted a scene', js: true do
    visit '/root'

    page.should_not have_content('Resume')
    page.should_not have_content('Start Over')

    page.should have_content('Try the Challenge')
  end

  # --------------------------------------------------------------------------

  scenario 'As a user who has attempted a scene', js: true do
    user = create :user

    create :scenario, scene: @scene, user: user, score: 518

    sign_in user
    visit '/root'

    page.should have_content('Resume')
    page.should have_content('Start Over')

    page.should_not have_content('Try the Challenge')
  end

end
