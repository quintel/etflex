application         = require 'app'
etliteTemplate      = require 'templates/etlite'

{ Range }           = require 'views/range'
{ SavingsMediator } = require 'mediators/savings_mediator'

# These fixtures are temporary, but act as acceptable stubs for models until a
# proper model class is added.
rangeFixtures =
  left:
    [ { name: 'Energy-saving bulbs',  value:  0, unit: '%', key: 'bulbs'      }
      { name: 'Electric cars',        value: 30, unit: '%', key: 'cars'       }
      { name: 'Better insulation',    value: 12, unit: '%', key: 'insulation' }
      { name: 'Solar power',          value: 24, unit: '%', key: 'solar'      }
      { name: 'Devices',              value: 56, unit: '%', key: 'devices'    }
      { name: 'Home heating',         value: 53, unit: '%', key: 'heating'    } ]
  right:
    [ { name: 'Coal power plants',    value: 0,    max: 7 }
      { name: 'Gas power plants',     value: 26,   max: 7 }
      { name: 'Nuclear power plants', value: 47,   max: 4 }
      { name: 'Wind turbines',        value: 1337, max: 10000 }
      { name: 'Solar panels',         value: 754,  max: 10000 }
      { name: 'Biomass',              value: 103,  max: 1606, unit: ' km<sup>2</sup>' } ]

# A full-page view which recreates the ETLite interface.
#
class exports.ETLite extends Backbone.View
  id: 'etlite-view'

  events:
    'click a': 'navigateToSanity'

  navigateToSanity: (event) ->
    application.router.navigate 'sanity', true
    false

  # Renders the view which for the moment simply confirms that the user is now
  # on the ETLite page.
  #
  render: ->
    $(@el).html etliteTemplate()

    leftRangesEl  = @$ '#savings'
    rightRangesEl = @$ '#energy-production'

    savingsMediator = new SavingsMediator

    _.each rangeFixtures.left, (range) ->
      leftRangesEl.append new Range(model: range).render(savingsMediator).el

    _.each rangeFixtures.right, (range) ->
      rightRangesEl.append(new Range(model: range).render().el)

    # Temporary; to demonstrate that the mediator works.
    savingsMediator.bind 'change:sum', (newValue) =>
      @$('#energy-generation').text "Sum: #{newValue}"

    savingsMediator.trigger 'change:sum'

    @delegateEvents()
    this
