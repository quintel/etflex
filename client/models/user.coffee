class exports.User
  # Creates a new User instance.
  constructor: ({ @id }) ->
    @isSignedIn = @id and "#{@id}"[0..1] isnt 'g:'
    @isGuest    = not @isSignedIn
