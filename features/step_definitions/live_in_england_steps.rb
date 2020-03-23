When("I visit the live in England page") do
  visit basic_care_needs_path
end

Then("I will be redirected to the NHS letter page") do
  expect(page.status_code).to eq(200)
  expect(page).to have_current_path(nhs_letter_path)
end
