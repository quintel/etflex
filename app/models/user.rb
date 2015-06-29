class User < ActiveRecord::Base
  # Exception raised when the user tries to do something for which they don't
  # have sufficient authorisation.
  class NotAuthorised < StandardError ; end

  include Gravtastic
  gravtastic rating: 'G', secure: false, size: 128, default: Guest::IMAGE_URL

  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  #
  devise :registerable, :recoverable, :rememberable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :remember_me,
                  :password, :password_confirmation,
                  :city, :country, :latitude, :longitude, :ip

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

  # INSTANCE METHODS ---------------------------------------------------------

  # The URL to a user's profile image.
  #
  # If the user signed up through Facebook, the returned string will contain a
  # URL to their Facebook profile image. Otherwise, it will seek to use the
  # user's e-mail address to fetch a gravatar image; falling back to the
  # default (guest) profile image.
  #
  # Returns a string.
  #
  def image_url
    image.presence or (email.present? and gravatar_url) or Guest::IMAGE_URL
  end

end # User
