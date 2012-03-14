require 'spec_helper'

feature 'Administering inputs' do

  background do
    sign_in create(:admin)
  end

  # --------------------------------------------------------------------------

  it_should_behave_like 'a backstage controller' do
    let(:path) { '/backstage/inputs' }
  end

  # --------------------------------------------------------------------------

  scenario 'Editing an input' do
    input = create :input, unit: '%'

    visit "/backstage/inputs/#{ input.id }/edit"

    # Inputs navigation element should be selected.
    page.should have_css('.navigation .inputs.selected')
    page.should have_css('h2', text: input.key)

    # ETengine ID and Key attributes should be disbaled.
    page.should have_css('#input_remote_id[disabled=disabled]')
    page.should have_css('#input_key[disabled=disabled]')

    # Pre-populated form.
    find 'form.edit_input' do |form|
      form.should have_css("#input_key",   value: input.key)
      form.should have_css("#input_step",  value: input.step)
      form.should have_css("#input_min",   value: input.min)
      form.should have_css("#input_max",   value: input.max)
      form.should have_css("#input_start", value: input.start)
      form.should have_css("#input_unit",  value: input.unit)
    end

    within 'form.edit_input' do
      fill_in 'Step' , with: '5'
      fill_in 'Min',   with: '50'
      fill_in 'Max',   with: '60.5'
      fill_in 'Start', with: '55'
      fill_in 'Unit',  with: 'MW'

      click_button 'Update Input'
    end

    # Should not be an error page.
    page.should_not have_css('form.edit_input')
    page.should     have_css('table#inputs')

    # Should be on the inputs page, not a scene inputs page.
    page.should     have_css('.navigation .inputs.selected')

    input.reload
    input.step.should  eql(5.0)
    input.min.should   eql(50.0)
    input.max.should   eql(60.5)
    input.start.should eql(55.0)
    input.unit.should  eql('MW')

  end # Editing an input

  # --------------------------------------------------------------------------

  scenario 'Failing to edit an input' do
    input = create :input
    orig  = input.key

    visit "/backstage/inputs/#{ input.id }/edit"

    # Fill in the "key" field so that it is empty.
    within 'form.edit_input' do
      fill_in 'Step', with: ''
      click_button 'Update Input'
    end

    page.should have_css('h2',         text: input.key)
    page.should have_css('span.error', text: "can't be blank")

    input.reload.key.should eql(orig)
  end

end
