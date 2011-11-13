require 'spec_helper'

describe 'Modules' do

  # --------------------------------------------------------------------------

  context 'retrieving a module', api: true do
    before  { visit '/modules/1' }
    subject { JSON.parse page.source }

    it { page.status_code.should eql(200) }

    it { should have_key('id')           }
    it { should have_key('name')         }
    it { should have_key('leftInputs')   }
    it { should have_key('rightInputs')  }
    it { should have_key('centerVis')    }
    it { should have_key('mainVis')      }
  end

  # --------------------------------------------------------------------------

end
