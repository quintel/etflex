# Embedded Inputs ------------------------------------------------------------

shared_examples_for 'an embedded scene input' do
  before { subject and subject.symbolize_keys!         }

  it { should_not be_nil                               }

  it { should include(key:       input.key)            }
  it { should include(start:     input.start)          }
  it { should include(min:       input.min)            }
  it { should include(max:       input.max)            }
  it { should include(step:      input.step)           }
  it { should include(unit:      input.unit)           }
  it { should include(position:  input.position)       }
  it { should include(location:  input.location)       }
  it { should include(remoteId:  input.remote_id)      }
  it { should include(group:     input.group)          }

  # Info is markdown-parsed.
  its([:info]) do
    if input.information_en.nil? then subject.should be_nil else
      subject.should match(input.information_en)
    end
  end
end

# Embedded Props -------------------------------------------------------------

shared_examples_for 'an embedded scene prop' do
  before { subject and subject.symbolize_keys!   }

  it { should_not be_nil                         }

  it { should include(key:       prop.key)       }
  it { should include(behaviour: prop.behaviour) }
  it { should include(position:  prop.position)  }
  it { should include(location:  prop.location)  }
  it { should include(hurdles:   prop.hurdles)   }
end

# Scene ----------------------------------------------------------------------

shared_examples_for 'scene JSON' do
  def at_location(location)
    lambda { |obj| obj.location == location }
  end

  context 'JSON' do
    subject { scene_json }

    it { should have_key('id')     }
    it { should have_key('name')   }
    it { should have_key('inputs') }
    it { should have_key('props')  }

    its(['inputs']) { should have(2).members }
    its(['props'])  { should have(2).members }
  end

  context 'inputs' do
    context 'the first input' do
      subject     { scene_json['inputs'].first }
      let(:input) { scene.scene_inputs.detect(&at_location('left')) }

      it_should_behave_like 'an embedded scene input'
    end # the first input

    context 'the second input' do
      subject     { scene_json['inputs'].last }
      let(:input) { scene.scene_inputs.detect(&at_location('right')) }

      it_should_behave_like 'an embedded scene input'
    end # the second input
  end # inputs

  context 'props' do
    context 'the first prop' do
      subject    { scene_json['props'].first }
      let(:prop) { scene.scene_props.detect(&at_location('center')) }

      it_should_behave_like 'an embedded scene prop'
    end # the first prop

    context 'the second prop' do
      subject    { scene_json['props'].last }
      let(:prop) { scene.scene_props.detect(&at_location('bottom')) }

      it_should_behave_like 'an embedded scene prop'
    end # the second prop
  end # props
end
