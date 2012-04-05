# Given data about a user, returns a User model which represents that data. If
# the data describes a guest who has not signed up, you will be returned a
# Guest instance instead.
#
exports.createUser = (data) ->
  userId = data?.id or ''

  if data?.actsLikeUser
    data
  else if "#{ userId }"[0..1] is 'g:'
    new Guest _.extend({}, data, { id: "#{ userId }"[2..-1] })
  else
    new User data

# Represents a visitor to ETFlex who has not yet signed up.
class Guest
  constructor: ({ @id, @name }) ->
    @actsLikeUser = true
    @isSignedIn   = false
    @isGuest      = true

# Represents a person who has signed up to ETFlex, either by providing their
# e-mail and password, or through Facebook.
#
class User extends Guest
  constructor: ({ @id, @name }) ->
    @isSignedIn = true
    @isGuest    = false
