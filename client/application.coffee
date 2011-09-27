# This is the initial boostrap file which is required in a <script> tag as
# part of the HTML. Don't add anything else here; rather add it to the $etf
# bootstrap method in etf.coffee

$ ->
  window.$etf = require('etf').$etf
  window.$etf.bootstrap()
