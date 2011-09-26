# This is a manifest file that'll be compiled into including all the files
# listed below. Add new JavaScript/Coffee code in separate files in this
# directory and they'll automatically be included in the compiled file
# accessible from http://example.com/assets/application.js. It's not advisable
# to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#
#= require_tree .

$ ->
  # Prove that CoffeeScript works.
  $('h1').css 'color', '#4b7b3d'

  # Prove that Eco templates work.
  $('p').append '<br />'
  $('p').append JST["templates/hello"](name: 'from an Eco template!')

  # Start the router; this is temporary until a proper boostrap process is
  # in place.
  new Router
  Backbone.history.start()
