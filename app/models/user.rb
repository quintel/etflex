class User < ActiveRecord::Base
  # Exception raised when the user tries to do something for which they don't
  # have sufficient authorisation.
  class NotAuthorised < StandardError ; end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

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
  def self.find_or_create_with_facebook(auth_hash)
    if user = User.find_by_email(auth_hash.info.email)
      user
    else
      User.create!({ email:    auth_hash.info.email, 
                     password: Devise.friendly_token[0,20], 
                     origin:   'facebook', 
                     image:    auth_hash.info.image,
                     name:     auth_hash.info.name,
                     uid:      auth_hash.uid,
                     token:    auth_hash.credentials.token
                   })
    end
  end
end
