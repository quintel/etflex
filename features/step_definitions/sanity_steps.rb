When /^I should see that the page loaded$/ do
  Then %(I should see "Hello from Eco and Backbone!")
end

When /^I should see the ETLite recreation$/ do
  Then %(I should see "Energy Production")
end
