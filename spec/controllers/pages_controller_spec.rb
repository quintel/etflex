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
end # PagesController
