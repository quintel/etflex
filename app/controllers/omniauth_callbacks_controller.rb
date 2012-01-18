class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # --- !ruby/hash:OmniAuth::AuthHash
  # provider: facebook
  # uid: '1252568565'
  # info: !ruby/hash:OmniAuth::AuthHash::InfoHash
  #   nickname: dennis.schoenmakers
  #   email: dennis.schoenmakers@gmail.com
  #   name: Dennis Schoenmakers
  #   first_name: Dennis
  #   last_name: Schoenmakers
  #   image: http://graph.facebook.com/1252568565/picture?type=square
  #   urls: !ruby/hash:Hashie::Mash
  #     Facebook: http://www.facebook.com/dennis.schoenmakers
  # credentials: !ruby/hash:Hashie::Mash
  #   token: AAAEYKztlzkgBAPWK02pRKXo8AyKouhML9I99kzV91Rzbrgx8mX7EUfElOjBdXAmabax8kQIoIX9AzG5NhZCEaAFV5ymkZD
  #   expires: false
  # extra: !ruby/hash:Hashie::Mash
  #   raw_info: !ruby/hash:Hashie::Mash
  #     id: '1252568565'
  #     name: Dennis Schoenmakers
  #     first_name: Dennis
  #     last_name: Schoenmakers
  #     link: http://www.facebook.com/dennis.schoenmakers
  #     username: dennis.schoenmakers
  #     gender: male
  #     email: dennis.schoenmakers@gmail.com
  #     timezone: 1
  #     locale: nl_NL
  #     verified: true
  #     updated_time: '2011-09-24T11:36:17+0000'
  def facebook
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_with_facebook(auth)    
    if @user.persisted?
       sign_in @user
       redirect_to root_path, notice: "succesfully signed in!"
    else
       raise auth.to_yaml
    end
  end
end