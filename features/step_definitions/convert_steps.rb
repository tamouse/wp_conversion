Given(/^a test export xml file$/) do
  $test_xml_file = File.join(File.expand_path("../../support",__FILE__),'test_data','test.xml')
  File.exist?($test_xml_file)
end

When(/^I successfully run "(.*?)" with(?: the "(.*?)" switch and)? the test file$/) do |arg1, switch|
  step("I successfully run `#{arg1} --#{switch} #{$test_xml_file}`")
end
