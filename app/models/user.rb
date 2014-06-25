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
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :name, length: { maximum: 50 }, allow_blank: true

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
