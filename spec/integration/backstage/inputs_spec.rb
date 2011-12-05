require 'spec_helper'

describe 'Administering inputs' do

  # --------------------------------------------------------------------------

  context 'Listing all', api: true do
    let(:json)      { JSON.parse page.source }
    let(:input_one) { create :input }
    let(:input_two) { create :mwh_input }

    before { input_one ; input_two }
    before { visit '/backstage/inputs' }

    describe 'response code' do
      it { page.status_code.should eql(200) }
    end

    describe 'the JSON document' do
      it { json.should be_kind_of(Hash) }
      it { json.should have_key('inputs') }
      it { json['inputs'].should have(2).members }
    end

    describe 'the first input in the collection' do
      subject { json['inputs'].first.symbolize_keys }

      it { should include(id:       input_one.id.to_s)   }
      it { should include(remoteId: input_one.remote_id) }
      it { should include(step:     input_one.step)      }
      it { should include(min:      input_one.min)       }
      it { should include(max:      input_one.max)       }
      it { should include(start:    input_one.start)     }
      it { should include(unit:     input_one.unit)      }

    end # the first input in the collection

    describe 'the second input in the collection' do
      subject { json['inputs'].last.symbolize_keys }

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

end
