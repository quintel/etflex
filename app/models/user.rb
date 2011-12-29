class User < ActiveRecord::Base
  # Exception raised when the user tries to do something for which they don't
  # have sufficient authorisation.
  class NotAuthorised < StandardError ; end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
