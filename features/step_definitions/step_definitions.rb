When "I visit the {string} path" do |path|
  visit path
end

When "I click the {string} button" do |button|
  click_button button
end

When "I click the {string} link" do |link|
  click_link link
end

When "I choose {string}" do |option|
  choose option
end

When "I fill in my name" do
  fill_in "first_name", with: "Test Please Ignore"
  fill_in "middle_name", with: "Test Please Ignore"
  fill_in "last_name", with: "Test Please Ignore"
end

When "I fill in my date of birth" do
  fill_in "date_of_birth-day", with: "1"
  fill_in "date_of_birth-month", with: "1"
  fill_in "date_of_birth-year", with: "1200"
end

When "I fill in my address" do
  fill_in "building_and_street_line_1", with: "Test Please Ignore"
  fill_in "building_and_street_line_2", with: "Test Please Ignore"
  fill_in "town_city", with: "Test Please Ignore"
  fill_in "county", with: "Test Please Ignore"
  fill_in "postcode", with: "ZZ99 9ZZ"
end

When "I fill in my contact details" do
  fill_in "phone_number_calls", with: "07000000000"
  fill_in "phone_number_texts", with: "07000000000"
  fill_in "email", with: "test@example.com"
end

Then "I can see a {string} heading" do |heading|
  expect(page).to have_css "h1"
  expect(find("h1").text).to eql(heading)
end

Then "I will be redirected to the {string} path" do |path|
  expect(page).to have_current_path(path)
end
