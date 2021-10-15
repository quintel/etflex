require 'rails_helper'

feature 'Editing scene props' do
  include ETFlex::Spec::SignIn

  background do
    @scene = create :scene
    @prop  = create :prop

    @scene_prop = @scene.scene_props.create(location: 'bottom') do |sp|
      sp.prop = @prop
    end

    sign_in create(:admin)
  end

  # --------------------------------------------------------------------------

  it_should_behave_like 'a backstage controller' do
    let(:path) { "/backstage/scenes/#{ @scene.id }/props" }
  end

  # --------------------------------------------------------------------------

  scenario 'Successfully adding a new scene prop' do
    # The prop we will be adding to the scene.
    @other = create :prop, key: 'second_prop'

    visit "/backstage/scenes/#{ @scene.id }/props"
    click_link 'Create Scene Prop'

    # Prop selection should be present and not disabled.
    page.should     have_css('#scene_prop_prop_id')
    page.should_not have_css('#scene_prop_prop_id[disabled=disabled]')

    within('form.new_scene_prop') do
      # select ..., from: 'Prop' wasn't working on Semaphore.
      find("[value='#{ @other.id }']").select_option
      fill_in 'Location',    with: 'bottom'

      click_button 'Create Scene prop'
    end

    # We should be returned to the scene prop list.
    page.should have_css('.navigation .scenes.selected')
    page.should have_css('table#props')

    # The scene prop was added?
    page.should have_css('td', text: @other.behaviour)
  end

  # --------------------------------------------------------------------------

  scenario 'Failing to add a scene prop' do
    # Visit the add scene prop page.
    visit "/backstage/scenes/#{ @scene.id }/props/new"

    # Empty a required field.
    within('form.new_scene_prop') do
      fill_in 'Location', with: ''

      expect { click_button 'Create Scene prop' }.to_not \
        change { SceneProp.count }
    end

    # Should be an error page.
    page.should     have_css("form#new_scene_prop")
    page.should_not have_css('table#props')

    page.should     have_css('.error', text: "can't be blank")
  end

  # --------------------------------------------------------------------------

  scenario 'Successfully updating the scene prop' do
    # Hold on to the values used by the Prop so we may later ensure that they
    # have not been changed.
    prop_originals = {
      key:       @prop.key,
      behaviour: @prop.behaviour
    }

    # Visit the edit scene prop page.
    visit "/backstage/scenes/#{ @scene.id }/props/#{ @scene_prop.id }/edit"

    # Prop selection should not  be present.
    page.should_not have_css('#scene_prop_prop_id')

    # Fill in required values.
    within('form.edit_scene_prop') do
      fill_in 'Location',             with: 'center'
      fill_in 'Position',             with: '42'

      click_button 'Update Scene prop'
    end

    # Should not be an error page.
    page.should_not have_css("form#edit_scene_prop_#{ @scene_prop.id }")
    page.should     have_css('table#props')

    # Should be on the scene props page, not the main props page.
    page.should     have_css('.navigation .scenes.selected')

    @prop.reload
    @scene_prop.reload

    # Ensure that the scene prop was updated.
    @scene_prop.location.should eql('center')
    @scene_prop.position.should eql(42)

    # ... and that the Prop wasn't.
    @prop.key.should       eql(prop_originals[:key])
    @prop.behaviour.should eql(prop_originals[:behaviour])
  end

  # --------------------------------------------------------------------------

  scenario 'Failing to update a scene prop' do
    # Visit the edit scene prop page.
    visit "/backstage/scenes/#{ @scene.id }/props/#{ @scene_prop.id }/edit"

    # Empty a required field.
    within('form.edit_scene_prop') do
      fill_in      'Location', with: ''
      click_button 'Update Scene prop'
    end

    # Should be an error page.
    page.should     have_css("form#edit_scene_prop_#{ @scene_prop.id }")
    page.should_not have_css('table#props')

    page.should     have_css('.error', text: "can't be blank")
  end

  # --------------------------------------------------------------------------

  scenario 'Deleting a scene prop' do
    visit "/backstage/scenes/#{ @scene.id }/props"

    # There should be only one scene prop, therefore one delete link.
    within('table#props') { click_link 'Delete' }

    # We should be returned to the scene prop list.
    page.should have_css('.navigation .scenes.selected')
    page.should have_css('table#props')

    # The scene prop was definitely deleted?
    page.should_not have_css('td.key a', text: @prop.behaviour)
  end

end
