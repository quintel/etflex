require 'spec_helper'

describe ETFlex::ClientResponder do
  render_views

  controller do
    include ETFlex::ClientController

    respond_to :json
    respond_to :html, only: [ :index, :show, :new, :edit ]

    def self.responder
      ETFlex::ClientResponder
    end

    def index
      respond_with @inputs = [ Input.first ]
    end

    def create
      if params[:fail]
        input = Input.new.tap { |i| i.valid? }
      else
        Input.first
      end

      respond_with input, location: '/'
    end
  end

  before(:each) { create :input }

  # --------------------------------------------------------------------------

  context 'a GET (index) request' do
    context 'when requesting HTML' do
      subject { get :index }

      it { should render_template('application/client') }
      it { subject.content_type.should eql('text/html') }
      it { subject.status.should eql(200) }
    end # when requesting HTML

    context 'when requesting JSON' do
      subject { get :index, format: 'json' }

      it { should_not render_template('application/client') }
      it { subject.content_type.should eql('application/json') }
      it { subject.status.should eql(200) }
    end # when requesting JSON
  end # a GET (index) request

  # --------------------------------------------------------------------------

  context 'a POST (create) request' do
    context 'when successful' do
      context 'when requesting HTML' do
        it 'should be 406 Not Acceptable' do
          post :create
          response.status.should eql(406)
        end
      end # when requesting HTML

      context 'when requesting JSON' do
        subject { post :create, format: 'json' }

        it { subject.status.should eql(201) }
        it { subject.headers.should include('Location' => '/') }
      end # when requesting JSON
    end # when successful

    context 'when it fails' do
      context 'when requesting HTML' do
        it 'should be 406 Not Acceptable' do
          post :create, fail: '1'
          response.status.should eql(406)
        end
      end # when requesting HTML

      context 'when requesting JSON' do
        subject { post :create, fail: '1', format: 'json' }
        before { pending '???' }

        it { response.status.should eql(200) }
        it { response.should_not render_template('application/client') }
        it { response.content_type.should eql('application/json') }
        it { puts response.body.inspect }
      end # when requesting JSON
    end # when it fails
  end # a POST (create) request

  # --------------------------------------------------------------------------

end
