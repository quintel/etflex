# encoding: utf-8

# Results --------------------------------------------------------------------

Then /^I should see an? "(.+)" range/ do |name|
  page.should have_css('.range .label', text: name)
end

Then /^the "(.+)" range value should be "(\d+)"$/ do |name, value|
  page.all('.range').each do |range|
    if range.has_css?('.label', text: name)
      range.should have_css('.output', text: value)
    end
  end
end
