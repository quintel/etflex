{ NotFoundView } = require 'views/not_found'

# A Backbone Router used for displaying error messages, and catches cases
# where no other router has a matching route.
#
class exports.Errors extends Backbone.Router
  routes:
    '*undefined': 'notFound'

  # A 404 Not Found page. Presents the user with a localised message guiding
  # them back to the front page.
  #
  # GET /*undefined
  #
  notFound: ->
    $('body').html (new NotFoundView).render().el
