require 'spec_helper'

describe PagesController do
  describe 'Changing language' do
    it 'should set "en"' do
      get :lang, locale: 'en'

      session[:locale].should eql('en')
      I18n.locale.should eql(:en)

      response.should redirect_to('/')
    end

    it 'should set "nl"' do
      get :lang, locale: 'nl'

      session[:locale].should eql('nl')
      I18n.locale.should eql(:nl)

      response.should redirect_to('/')
    end

    it 'should redirect to internal urls' do
      get :lang, locale: 'nl', backto: '/place'

      response.should redirect_to('/place')
    end

    it 'should not redirect to external urls' do
      get :lang, locale: 'en', backto: 'http://place'

      response.should redirect_to('/')
    end
  end # Changing language

  describe 'Updating the name of a user' do
    let!(:user) { create :user }

    before do
      sign_in user
      put :update_username, user: { name: 'New Name' }, format: :json
    end

    it 'should respond with 204 No Content' do
      response.status.should eql(204)
    end

    it 'should update the user name' do
      user.reload.name.should eql('New Name')
    end
  end

  describe 'Updating the name of a guest' do
    before do
      put :update_username, user: {} # Force guest to be created.

      @scenario = create(:guest_scenario,
        guest_uid: cookies.signed[:guest][:id])

      put :update_username, user: { name: 'New Name' }
    end

    it 'should respond with 204 No Content' do
      response.status.should eql(204)
    end

    it 'should update the user name' do
      cookies.signed[:guest][:name].should eql('New Name')
    end

    it 'should update the guest name on scenarios' do
      @scenario.reload.guest_name.should eql('New Name')
    end
  end
end # PagesController
