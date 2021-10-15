require 'rails_helper'

describe ETFlex::PropAnalyzer do
  context 'when given a prop with an illegal behaviour' do
    it 'should raise an error' do
      expect {
        ETFlex::PropAnalyzer.new(Prop.new(behaviour: 'nope'))
      }.to raise_error('No such prop behaviour in the map: nope')
    end
  end

  context 'when given a valid prop' do
    subject do
      ETFlex::PropAnalyzer.new(Prop.new(behaviour: 'co2-emissions'))
    end

    it 'should set the mapping' do
      subject.mapping.behaviour.should eql('co2-emissions')
    end

    describe 'queries when the prop uses one Gquery' do
      before do
        content = File.read(Rails.root.join(
          'spec/fixtures/prop_with_one_query.coffee'))

        File.should_receive(:read).
          with(Rails.root.join('client/views/props/co2_emissions.coffee')).
          and_return(content)
      end

      it 'should return one query' do
        subject.queries.should have(1).member
      end

      it 'should return the queries used' do
        subject.queries.should include('total_co2_emissions')
      end
    end # queries when the prop uses one Gquery

    describe 'queries when the prop uses four Gqueries' do
      before do
        content = File.read(Rails.root.join(
          'spec/fixtures/prop_with_four_queries.coffee'))

        File.should_receive(:read).
          with(Rails.root.join('client/views/props/co2_emissions.coffee')).
          at_least(:once).and_return(content)
      end

      it 'should return four queries' do
        subject.queries.should have(4).members
      end

      it 'should return the queries used' do
        subject.queries.should include('total_electricity_produced')
        subject.queries.should include('electricity_produced_from_uranium')
        subject.queries.should include('electricity_produced_from_solar')
        subject.queries.should include('electricity_produced_from_oil')
      end
    end

  end # when given a valid prop
end # PropAnalyzer
