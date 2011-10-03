# encoding: utf-8

# Results --------------------------------------------------------------------

Then /^I should see an? "(.+)" slider$/ do |name|
  page.should have_css('.slider .label', text: name)
end

Then /^the "(.+)" slider value should be "(\d+)"$/ do |name, value|
  page.all('.slider').each do |slider|
    if slider.has_css?('.label', text: name)
      slider.should have_css('.output', text: value)
    end
  end
end
