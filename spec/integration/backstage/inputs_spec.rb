require 'spec_helper'

describe 'Administering inputs' do

  # --------------------------------------------------------------------------

  context 'Listing all through the API', api: true do
    let(:json)      { JSON.parse page.source }
    let(:input_one) { create :input }
    let(:input_two) { create :mwh_input }

    before { input_one ; input_two }
    before { visit '/backstage/inputs' }

    describe 'response code' do
      it { page.status_code.should eql(200) }
    end

    describe 'the JSON document' do
      it { json.should be_kind_of(Array) }
      it { json.should have(2).members }
    end

    describe 'the first input in the collection' do
      subject { json.detect { |m| m['id'] == input_one.id }.symbolize_keys }

      it { should include(id:       input_one.id)   }
      it { should include(remoteId: input_one.remote_id) }
      it { should include(step:     input_one.step)      }
      it { should include(min:      input_one.min)       }
      it { should include(max:      input_one.max)       }
      it { should include(start:    input_one.start)     }
      it { should include(unit:     input_one.unit)      }

    end # the first input in the collection

    describe 'the second input in the collection' do
      subject { json.detect { |m| m['id'] == input_two.id }.symbolize_keys }

      it { should include(id:       input_two.id)   }
      it { should include(remoteId: input_two.remote_id) }
      it { should include(step:     input_two.step)      }
      it { should include(min:      input_two.min)       }
      it { should include(max:      input_two.max)       }
      it { should include(start:    input_two.start)     }
      it { should include(unit:     input_two.unit)      }

    end # the second input in the collection
  end # Listing all inputs

  # --------------------------------------------------------------------------

  specify 'Editing an input' do
    input = create :input, unit: '%'

    visit "/backstage/inputs/#{ input.id }/edit"

    # Inputs navigation element should be selected.
    page.should have_css('.navigation .inputs.selected')
    page.should have_css('h2', text: input.key)

    # ETengine ID and Key attributes should be disbaled.
    page.should have_css('#input_remote_id[disabled=disabled]')
    page.should have_css('#input_key[disabled=disabled]')

    # Pre-populated form.
    find 'form.input' do |form|
      form.should have_css("#input_key",   value: input.key)
      form.should have_css("#input_step",  value: input.step)
      form.should have_css("#input_min",   value: input.min)
      form.should have_css("#input_max",   value: input.max)
      form.should have_css("#input_start", value: input.start)
      form.should have_css("#input_unit",  value: input.unit)
    end

    within 'form.input' do
      fill_in 'Step' , with: '5'
      fill_in 'Min',   with: '50'
      fill_in 'Max',   with: '60.5'
      fill_in 'Start', with: '55'
      fill_in 'Unit',  with: 'MW'

      click_button 'Update Input'
    end

    # Should not be an error page.
    page.should_not have_css('form.input')
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

  specify 'Failing to edit an input' do
    input = create :input
    orig  = input.key

    visit "/backstage/inputs/#{ input.id }/edit"

    # Fill in the "key" field so that it is empty.
    within 'form.input' do
      fill_in 'Step', with: ''
      click_button 'Update Input'
    end

    page.should have_css('h2',         text: input.key)
    page.should have_css('span.error', text: "can't be blank")

    input.reload.key.should eql(orig)
  end

end
