/**
 * This is a manifest file that'll be compiled into including all the files
 * listed below. Add new JavaScript/Coffee code in separate files in this
 * directory and they'll automatically be included in the compiled file
 * accessible from http://example.com/assets/application.js. It's not advisable
 * to add code directly here, but if you do, it'll appear at the bottom of the
 * the compiled file.
 * DEBT: We need to make a shift here of what's needed and what's not
 *
 *= require jquery
 *= require jquery_ujs
 *= require jquery.easing.1.3
 *= require jquery.ba-outside-events
 *= require jquery.reveal
 *= require jquery.cookie
 *= require underscore
 *= require backbone
 *= require jquery.quinn
 *= require jquery.quinn.balancer
 *= require async
 *= require i18n
 *= require i18n/translations
 *= require header_animation
 *= require ./stitch_preamble
 *= require_tree ../../../client
 */

jQuery.easing.def = 'easeInOutQuart';
