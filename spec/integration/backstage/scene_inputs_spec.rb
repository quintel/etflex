require 'spec_helper'

feature 'Editing scene inputs' do

  background do
    @scene = create :scene
    @input = create :input

    @scene_input = @scene.scene_inputs.create(input: @input, location: 'left')
  end

  # --------------------------------------------------------------------------

  scenario 'Successfully adding a new scene input' do
    # The input we will be adding to the scene.
    @other = create :input

    visit "/backstage/scenes/#{ @scene.id }/inputs"

    within('form.scene_input') do
      select @other.key, from: 'Input'
      select 'Left',     from: 'Location'

      click_button 'Create Scene input'
    end

    # We should be returned to the scene input list.
    page.should have_css('.navigation .scenes.selected')
    page.should have_css('table#inputs')

    # The scene input was added?
    page.should have_css('td.key a', content: @other.key)
  end

  # --------------------------------------------------------------------------

  scenario 'Successfully updating the scene input' do
    visit "/backstage/scenes/#{ @scene.id }/inputs"

    # Hold on to the values used by the Input so we may later ensure that they
    # have not been changed.
    input_originals = {
      step:  @input.step,
      min:   @input.min,
      max:   @input.max,
      start: @input.start,
    }

    # Visit the edit scene input page.
    within('#inputs') { click_link @input.key }

    # Default values don't appear on the form.
    page.should have_css('#scene_input_step',  value: '')
    page.should have_css('#scene_input_min',   value: '')
    page.should have_css('#scene_input_max',   value: '')
    page.should have_css('#scene_input_start', value: '')

    # ETengine ID and Key attributes should be disbaled.
    page.should have_css('#scene_input_remote_id[disabled=disabled]')
    page.should have_css('#scene_input_key[disabled=disabled]')

    page.should_not have_css('#scene_input_unit')

    # Fill in custom values for all fields.
    within('form.scene_input') do
      fill_in 'Step by',        with: '5.5'
      fill_in 'Minimum value',  with: '12'
      fill_in 'Maximum value',  with: '72'
      fill_in 'Starting value', with: '42'

      click_button 'Update Scene input'
    end

    # Should not be an error page.
    page.should_not have_css('form.scene_input')
    page.should     have_css('table#inputs')

    # Should be on the scene inputs page, not the main inputs page.
    page.should     have_css('.navigation .scenes.selected')

    @input.reload
    @scene_input.reload

    # Ensure that the scene input was updated ...
    @scene_input.step.should  eql(5.5)
    @scene_input.min.should   eql(12.0)
    @scene_input.max.should   eql(72.0)
    @scene_input.start.should eql(42.0)

    # ... and that the Input wasn't.
    @input.step.should  eql(input_originals[:step])
    @input.min.should   eql(input_originals[:min])
    @input.max.should   eql(input_originals[:max])
    @input.start.should eql(input_originals[:start])

    # Custom values appear on the form?
    visit "/backstage/scenes/#{ @scene.id }/inputs/#{ @scene_input.id }/edit"

    page.should have_css('#scene_input_step',  value: '5.5')
    page.should have_css('#scene_input_min',   value: '12.0')
    page.should have_css('#scene_input_max',   value: '72.0')
    page.should have_css('#scene_input_start', value: '42.0')
  end

end
