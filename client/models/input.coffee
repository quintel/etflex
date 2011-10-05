# Represents an externally-controlled variable, such as those used in
# ETEngine. Users can change the selected value of the Input to alter
# the scenario to meet their goals.
#
class exports.Input extends Backbone.Model
  # These will eventually come from ETEngine.
  defaults:
    name:  'An Input'
    unit:  ''
    value:    0
    min:      0
    max:    100
