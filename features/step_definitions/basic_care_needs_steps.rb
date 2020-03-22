When("I visit the basic care needs page") do
  visit coronavirus_form_basic_care_needs_path
end

Then("I will be redirected to the dietary requirements page") do
  expect(page.status_code).to eq(200)
  expect(page).to have_current_path(coronavirus_form_dietary_requirements_path)
end
