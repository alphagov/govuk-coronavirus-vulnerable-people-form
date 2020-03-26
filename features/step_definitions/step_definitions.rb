When "I visit the {string} path" do |path|
  visit path
end

When "I choose {string}" do |option|
  choose option
end

When "I click the {string} button" do |button|
  click_button button
end

When "I click the {string} link" do |link|
  click_link link
end

Then "I can see a {string} heading" do |heading|
  expect(page).to have_css "h1"
  expect(find("h1").text).to eql(heading)
end

Then "I will be redirected to the {string} path" do |path|
  expect(page).to have_current_path(path)
end
