# Given data about a user, returns a User model which represents that data. If
# the data describes a guest who has not signed up, you will be returned a
# Guest instance instead.
#
exports.createUser = (data) ->
  if "#{ data.id }"[0..1] is 'g:' or not data.id?
    new Guest _.extend({}, data, { id: "#{data.id}"[2..-1] })
  else
    new User data

# Represents a person who has signed up to ETFlex, either by providing their
# e-mail and password, or through Facebook.
#
class User
  constructor: ({ @id }) ->
    @isSignedIn = true
    @isGuest    = false

# Represents a visitor to ETFlex who has not yet signed up.
class Guest
  constructor: ({ @id }) ->
    @isSignedIn = false
    @isGuest    = true
