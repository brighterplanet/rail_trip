require 'rspec/mocks'
RSpec::Mocks.setup self
include RSpec::Mocks::ExampleMethods

Given /^mapquest determines the distance in miles to be "([^\"]*)"$/ do |distance|
  if distance.present?
    mockquest = double MapQuestDirections, :status => 0, :xml => "<distance>" + distance.to_s + "</distance>"
  else
    mockquest = double MapQuestDirections, :status => 601, :xml => "<distance>0</distance>"
  end
  MapQuestDirections.stub!(:new).and_return mockquest
end

Given /^the geocoder will encode the (.*) as "(.*)" in "(.*)"$/ do |component, location, country|
  @expectations << lambda do
    components = @characteristics ? @characteristics : @activity_hash
    component_value = components[component.to_sym].to_s
    result = mock Object, :coordinates => location.split(',').map(&:to_f), :country_code => country
    Geocoder.stub!(:search).with(component_value).and_return [result]
  end
end

Given /^the geocoder will fail to encode the (.*)$/ do |component|
  Geocoder.stub!(:search).and_return []
end

Then /^the conclusion of the committee should be located at "(.*)"$/ do |value|
  compare_values @report.conclusion.coordinates, value.split(',').map(&:to_f)
end
