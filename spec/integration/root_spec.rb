require 'spec_helper'

feature 'Viewing the root page' do

  background do
    @scene = create :scene
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, listing the scenes', js: true do
    visit '/'

    page.status_code.should eql(200)
    page.should have_css("#scene_#{ @scene.id }", content: @scene.name)

    page.should     have_css('#main-nav #nav-user')
    page.should_not have_css('#main-nav #nav-account')
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, listing the scenes', js: true do
    sign_in create(:user)

    visit '/'

    page.status_code.should eql(200)
    page.should have_css("#scene_#{ @scene.id }", content: @scene.name)

    page.should_not have_css('#main-nav #nav-user')
    page.should     have_css('#main-nav #nav-account')
  end
end
