When("I visit the live in England page") do
  visit live_in_england_path
end

Then("I will be redirected to the NHS letter page") do
  expect(page.status_code).to eq(200)
  expect(page).to have_current_path(nhs_letter_path)
end
