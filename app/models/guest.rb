class Guest
  # Returns the unique guest ID as a String.
  attr_reader :id

  # Returns the name the user gave, or nil if no name has been provided.
  attr_accessor :name

  # Path to the guest user profile image.
  #
  # TODO This should be part of a view, not the model; move as soon as
  #      Scenario#to_pusher_event is extracted from the model.
  #
  IMAGE_URL = 'http://etflex.et-model.com/assets/guest.png'.freeze

  # Creates a new Guest.
  #
  # id   - The unique ID assigned to the guest.
  # name - A string containing the guest's name.
  #
  def initialize(id = SecureRandom.uuid, name = nil)
    @id, @name = id, name
  end

  # Returns the URL of the image used to idenfity guests, relative to the web
  # root.
  #
  def image_url
    # the IMAGE_URL constant above is used by Gravtastic, that is expecting an
    # absolute URL
    '/assets/guest.png'
  end

  # Public: Saves the guest into a cookie.
  #
  # cookies - The controller cookie jar.
  #
  # Example:
  #   # (in a controller)
  #   guest.save cookies
  #
  def save(cookies)
    cookies.permanent.signed[:guest] = {
      httponly: true, value: { id: id, name: name } }
  end

  # Public: Given the controller cookie jar, constructs a Guest.
  #
  # If the cookie jar does not contain attributes to make the user, a brand
  # new Guest will be returned instead with the values automatically saved to
  # the cookies.
  #
  # cookies - The controller cookie jar.
  #
  def self.from_cookies(cookies)
    cookie = cookies.signed[:guest]

    if cookie.present?
      new *cookie.values_at(:id, :name)
    else
      new.tap { |guest| guest.save(cookies) }
    end
  end

end # Guest
