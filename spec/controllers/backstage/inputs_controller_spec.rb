require 'spec_helper'

describe Backstage::InputsController do

  # UPDATE -------------------------------------------------------------------

  describe 'Updating an input' do
    let(:input) { create(:input) }

    describe 'with valid data' do
      before do
        put :update, format: 'json', id: input.id, input: { step: '500' }
      end

      it 'should be 200 OK' do
        response.status.should eql(200)
      end

      it 'should set the new values' do
        input.reload.step.should eql(500.0)
      end

      it 'should return an empty document' do
        response.body.should eql('{}')
      end
    end # with valid data

    describe 'with invalid data' do
      before do
        put :update, format: 'json', id: input.id, input: { step: '' }
      end

      it 'should be 422 Unprocessable Entity' do
        response.status.should eql(422)
      end

      it 'should return the error document' do
        JSON.parse(response.body).should have_key('step')
      end
    end # when invalid data
  end # Updating an input

end # Backstage::InputsController
