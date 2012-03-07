# Used on static pages to animate the header elements. Pass in the header DOM
# element when initializing:
#
#   new StaticHeader el: $('#theme-header')
#
class exports.StaticHeader extends Backbone.View

  # Sets up the animation.
  render: ->
    @props     = @$ '.icon-prop'
    @propCount = @props.length

    @queueNextAnimation()

    this

  # Performs an animation; chooses a header prop and random and changes it to
  # a different state. After completion, sets up the next animation to happen
  # in three seconds.
  #
  # If the user navigates away from the root page, this animation is not
  # performed, no next animation will be queued.
  #
  performAnimation: =>
    return false unless $('#page-view.root').length

    randomIndex  = Math.floor( Math.random() * @propCount )
    selectedProp = @props.eq randomIndex

    toHide = selectedProp.find('.active')
    toShow = selectedProp.find('.inactive').first()

    console.log toHide, toShow

    toHide.removeClass('active').addClass('inactive').fadeOut 1000
    toShow.removeClass('inactive').addClass('active').fadeIn  1000

    @queueNextAnimation()

  # Queues the next animation to happen in three seconds.
  queueNextAnimation: ->
    _.delay @performAnimation, 3000
