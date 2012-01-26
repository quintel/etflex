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

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :remember_me,
                  :password, :password_confirmation

  # Creates a new user based on an AuthHash given by OmniAuth after
  # authenticating the user with facebook. Will not create a user if the
  # e-mail matches an existing user.
  #
  # The OmniAuth has looks like:
  #
  #   provider:          facebook
  #   uid:              '1252568565'
  #   info:
  #     nickname:        dennis.schoenmakers
  #     email:           dennis.schoenmakers@gmail.com
  #     name:            Dennis Schoenmakers
  #     first_name:      Dennis
  #     last_name:       Schoenmakers
  #     image:           http://graph.facebook.com/1252568565/picture
  #     urls:
  #       Facebook:      http://www.facebook.com/dennis.schoenmakers
  #   credentials:
  #     token:           AAAEYKztlzkgBAPWK02pRKXo8AyKouhML9I99kzV91Rzbrg \
  #                      x8mX7EUfElOjBdXAmabax8kQIoIX9AzG5NhZCEaAFV5ymkZD
  #     expires:         false
  #   extra:
  #     raw_info:
  #       id:           '1252568565'
  #       name:          Dennis Schoenmakers
  #       first_name:    Dennis
  #       last_name:     Schoenmakers
  #       link:          http://www.facebook.com/dennis.schoenmakers
  #       username:      dennis.schoenmakers
  #       gender:        male
  #       email:         dennis.schoenmakers@gmail.com
  #       timezone:      1
  #       locale:        nl_NL
  #       verified:      true
  #       updated_time: '2011-09-24T11:36:17+0000'
  #
  def self.find_or_create_with_facebook!(auth_hash)
    if user = User.find_by_email(auth_hash.info.email) then user else
      User.create! do |user|
        user.email    = auth_hash.info.email
        user.password = Devise.friendly_token[0,20]
        user.origin   = 'facebook'
        user.image    = auth_hash.info.image
        user.name     = auth_hash.info.name
        user.uid      = auth_hash.uid
        user.token    = auth_hash.credentials.token
      end
    end
  end

end # User
