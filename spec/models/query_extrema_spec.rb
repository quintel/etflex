require 'spec_helper'

describe ETFlex::QueryExtrema do
  context 'when initialized with query values' do
    let(:data) do
      { 'nl' => { 'query_key' => [ 0, 103 ] },
        'uk' => { 'query_key' => [ 1, 185 ] } }
    end

    subject { ETFlex::QueryExtrema.new(data) }

    describe 'for_query' do
      context 'given a valid query key' do
        it 'should return a value for "nl"' do
          subject.for_query('query_key', 'nl').should eql([0, 103])
        end

        it 'should return a value for "uk"' do
          subject.for_query('query_key', 'uk').should eql([1, 185])
        end

        it 'should not return a value for "de"' do
          subject.for_query('query_key', 'de').should be_nil
        end

        it 'should not return a value for an invalid query' do
          subject.for_query('invalid', 'nl').should be_nil
        end
      end
    end

    describe 'as_json' do
      it { subject.as_json.should eql(data) }

      it 'should clone the original hash, not return it' do
        subject.as_json.object_id.should_not eql(data.object_id)
      end
    end
  end
end # ETFlex::QueryExtrema
