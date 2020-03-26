When "I visit the {string} path" do |path|
  visit path
end

When "I click the {string} button" do |button|
  click_button button
end

When "I click the {string} link" do |link|
  click_link link
end

When "I answer {string}" do |option|
  choose option
  click_button "Continue"
end

Then "I can see {string} in the heading" do |heading|
  expect(page).to have_css "h1"
  expect(find("h1")).to have_text(heading, exact: false)
end

Then "I can see {string}" do |content|
  expect(page).to have_content(content, exact: false)
end

Then "I will be redirected to the {string} path" do |path|
  expect(page).to have_current_path(path)
end
