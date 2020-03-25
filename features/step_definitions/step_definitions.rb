When "I visit the {string} path" do |path|
  visit path
end

Then "I can see a {string} heading" do |heading|
  expect(page).to have_css "h1"
  expect(find("h1").text).to eql(heading)
end

Then "I choose {string}" do |option|
  choose option
end

Then "I click the {string} button" do |button|
  click_on button
end

Then "I will be redirected to the {string} path" do |path|
  expect(page).to have_current_path(path)
end
