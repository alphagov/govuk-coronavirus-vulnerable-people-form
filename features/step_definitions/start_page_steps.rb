When("I visit the start page") do
  visit "/"
end

Then("I can see the page is a work in progress") do
  expect(page).to have_content("Work in progress")
end

Then("I will be redirected to the start page") do
  expect(page.status_code).to eq(200)
  expect(page).to have_current_path("/")
end
