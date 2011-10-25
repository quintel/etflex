require 'spec_helper'

describe 'The ETlite recreation' do

  # --------------------------------------------------------------------------

  specify 'Viewing the ETlite recreation',  js: true do
    visit '/etlite'

    # Low-energy lighting.

    page.should have_css('.label', text: 'Low-energy lighting')

    # Test that the Low-energy lighting range value is 0
    #
    # TODO Find a nice way to extract this into a method. Perhaps an
    #      RSpec matcher?
    #
    #      page.should have_range('Electric cars', value: 0)
    #
    page.all('.range').each do |range|
      if range.has_css?('.label', text: 'Low-energy lighting')
        range.should have_css('.output', text: '0')
      end
    end

    # Electric cars.

    page.should have_css('.label', text: 'Electric cars')

    page.all('.range').each do |range|
      if range.has_css?('.label', text: 'Electric cars')
        range.should have_css('.output', text: '0')
      end
    end

  end

  # --------------------------------------------------------------------------

end
