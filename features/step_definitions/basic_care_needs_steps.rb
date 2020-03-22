When("I visit the basic care needs page") do
  visit basic_care_needs_path
end

Then("I will be redirected to the dietary requirements page") do
  expect(page.status_code).to eq(200)
  expect(page).to have_current_path(dietary_requirements_path)
end
