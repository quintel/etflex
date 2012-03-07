Guest = Struct.new(:id) do
  # Path to the guest user profile image.
  #
  # TODO This should be part of a view, not the model; move as soon as
  #      Scenario#to_pusher_event is extracted from the model.
  #
  IMAGE_URL = 'http://beta.etflex.et-model.com/assets/guest.png'.freeze

  # Returns as a String the URL, relative to the web root, of the image which
  # should be used to identify guests.
  #
  def image_url
    IMAGE_URL
  end
end
