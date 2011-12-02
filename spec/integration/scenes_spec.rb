require 'spec_helper'

describe 'Scenes' do

  context 'retrieving a list of scenes', api: true do
    let(:json) { JSON.parse page.source }

    before { @scene = create :scene, name_key: 'test' }
    before { visit '/scenes' }

    subject { json }

    it { page.status_code.should eql(200) }
    it { should be_kind_of(Hash) }
    it { should have_key('scenes') }

    context 'a Scene in the collection' do
      subject { json['scenes'].first }

      it { should have_key('id')       }
      it { should have_key('href')     }
      it { should have_key('name')     }
      it { should have_key('name_key') }
    end
  end

  # --------------------------------------------------------------------------

  context 'retrieving a scene', api: true do
    let(:scene) { create :scene }

    before  { visit "/scenes/#{scene.id}" }
    subject { JSON.parse page.source }

    it { page.status_code.should eql(200) }

    it { should have_key('id')        }
    it { should have_key('name')      }
    it { should have_key('inputs')    }
    it { should have_key('centerVis') }
    it { should have_key('mainVis')   }
  end

  # --------------------------------------------------------------------------

end
