require 'spec_helper'

describe Scenario do
  it { should successfully_save }

  # ATTRIBUTES --------------------------------------------------------------

  it { should_not allow_mass_assignment_of(:user) }
  it { should_not allow_mass_assignment_of(:user_id) }

  it { should_not allow_mass_assignment_of(:scene) }
  it { should_not allow_mass_assignment_of(:scene_id) }

  it { should_not allow_mass_assignment_of(:session_id) }
  it { should_not allow_mass_assignment_of(:score) }

  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:input_values) }
  it { should allow_mass_assignment_of(:query_results) }

  # RELATIONS ----------------------------------------------------------------

  it { should belong_to(:user) }
  it { should belong_to(:scene) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:scene_id) }
  it { should validate_presence_of(:session_id) }

  it {
    create :scenario
    should validate_uniqueness_of(:session_id) }

  # SERIALIZE ATTRIBUTES -----------------------------------------------------

  describe '#input_values=' do
    it 'should set an empty hash when given nil' do
      scenario = Scenario.new input_values: nil
      scenario.input_values.should eql(Hash.new)
    end

    it 'should set an empty hash when given an empty hash' do
      scenario = Scenario.new input_values: {}
      scenario.input_values.should eql(Hash.new)
    end

    it 'should convert a hash-like value to a Hash' do
      scenario = Scenario.new input_values: {}.with_indifferent_access

      scenario.input_values.class.should eql(Hash)
      scenario.input_values.class.should_not \
        eql(ActiveSupport::HashWithIndifferentAccess)
    end

    it 'should set convert keys to integers when given a hash' do
      scenario = Scenario.new input_values: { '1' => '2' }
      scenario.input_values.should eql(1 => '2')
    end
  end

  describe '#query_results=' do
    it 'should set an empty hash when given nil' do
      scenario = Scenario.new query_results: nil
      scenario.query_results.should eql(Hash.new)
    end

    it 'should set an empty hash when given an empty hash' do
      scenario = Scenario.new query_results: {}
      scenario.query_results.should eql(Hash.new)
    end

    it 'should convert a hash-like value to a Hash' do
      scenario = Scenario.new query_results: {}.with_indifferent_access

      scenario.query_results.class.should eql(Hash)
      scenario.query_results.class.should_not \
        eql(ActiveSupport::HashWithIndifferentAccess)
    end

    it 'should set a hash' do
      scenario = Scenario.new query_results: { '1' => '2' }
      scenario.query_results.should eql('1' => '2')
    end

    it 'should also set a score when present' do
      scenario = Scenario.new query_results: { 'score' => 1337 }
      scenario.score.should eql(1337.0)
    end

    it 'should unset the score when not present' do
      scenario = Scenario.new { |s| s.score = 42.0 }

      expect { scenario.attributes = { query_results: {} } }.to \
        change { scenario.score }.from(42.0).to(nil)
    end
  end

end
