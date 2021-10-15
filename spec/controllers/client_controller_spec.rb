require 'rails_helper'

describe ETFlex::ClientController do
  controller(ApplicationController) do
    include ETFlex::ClientController

    def index ;   respond_with([]) ; end
    def show ;    respond_with({}) ; end
    def new ;     respond_with({}) ; end
    def create ;  respond_with({}, location: '/') ; end
    def edit ;    respond_with({}) ; end
    def update ;  respond_with({}, location: '/') ; end
    def destroy ; respond_with({}) ; end
  end

  # --------------------------------------------------------------------------

  describe 'GET /' do
    it 'should accept HTML' do
      get :index
      response.status.should eql(200)
    end

    it 'should accept JSON' do
      get :index, format: :json
      response.status.should eql(200)
    end
  end

  # --------------------------------------------------------------------------

  describe 'GET /:id' do
    it 'should accept HTML' do
      get :show, id: '1'
      response.status.should eql(200)
    end

    it 'should accept JSON' do
      get :show, id: '1', format: :json
      response.status.should eql(200)
    end
  end

  # --------------------------------------------------------------------------

  describe 'GET /new' do
    it 'should accept HTML' do
      get :new
      response.status.should eql(200)
    end

    it 'should accept JSON' do
      get :new, format: :json
      response.status.should eql(200)
    end
  end

  # --------------------------------------------------------------------------

  describe 'GET /edit' do
    it 'should accept HTML' do
      get :edit, id: '1'
      response.status.should eql(200)
    end

    it 'should accept JSON' do
      get :edit, id: '1', format: :json
      response.status.should eql(200)
    end
  end

  # --------------------------------------------------------------------------

  describe 'POST /' do
    it 'should not accept HTML' do
      post :create
      response.status.should eql(406)
    end

    it 'should accept JSON' do
      post :create, format: :json
      response.status.should eql(201)
    end
  end

  # --------------------------------------------------------------------------

  describe 'PUT /:id' do
    it 'should not accept HTML' do
      put :update, id: '1'
      response.status.should eql(406)
    end

    it 'should accept JSON' do
      put :update, id: '1', format: :json
      response.status.should eql(204)
    end
  end

  # --------------------------------------------------------------------------

  describe 'DELETE /:id' do
    it 'should not accept HTML' do
      delete :destroy, id: '1'
      response.status.should eql(406)
    end

    it 'should accept JSON' do
      delete :destroy, id: '1', format: :json
      response.status.should eql(204)
    end
  end

  # --------------------------------------------------------------------------

  describe 'client method' do
    it 'should not be reachable' do
      expect { get :client }.
        to raise_error(ActionController::UrlGenerationError)
    end
  end

end
