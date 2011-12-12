require 'spec_helper'

describe 'Administering inputs' do

  # --------------------------------------------------------------------------

  context 'Listing all through the API', api: true, pending: true do
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
      subject { json.first.symbolize_keys }

      it { should include(id:       input_one.id.to_s)   }
      it { should include(remoteId: input_one.remote_id) }
      it { should include(step:     input_one.step)      }
      it { should include(min:      input_one.min)       }
      it { should include(max:      input_one.max)       }
      it { should include(start:    input_one.start)     }
      it { should include(unit:     input_one.unit)      }

    end # the first input in the collection

    describe 'the second input in the collection' do
      subject { json.last.symbolize_keys }

      it { should include(id:       input_two.id.to_s)   }
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
      fill_in 'Key',   with: 'new_input_key'
      fill_in 'Step' , with: '5'
      fill_in 'Min',   with: '50'
      fill_in 'Max',   with: '60.5'
      fill_in 'Start', with: '55'
      fill_in 'Unit',  with: 'MW'

      click_button 'Update Input'
    end

    # TODO Then "I should not see an error message"

    input.reload
    input.key.should   eql('new_input_key')
    input.step.should  eql(5.0)
    input.min.should   eql(50.0)
    input.max.should   eql(60.5)
    input.start.should eql(55.0)
    input.unit.should  eql('MW')

  end # Editing an input

end
