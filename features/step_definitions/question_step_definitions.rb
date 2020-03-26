When "I fill in my name" do
  fill_in "first_name", with: "Test Please Ignore"
  fill_in "middle_name", with: "Test Please Ignore"
  fill_in "last_name", with: "Test Please Ignore"
  click_button "Continue"
end

When "I fill in my date of birth" do
  fill_in "date_of_birth-day", with: "1"
  fill_in "date_of_birth-month", with: "1"
  fill_in "date_of_birth-year", with: "1200"
  click_button "Continue"
end

When "I fill in my address" do
  fill_in "building_and_street_line_1", with: "Test Please Ignore"
  fill_in "building_and_street_line_2", with: "Test Please Ignore"
  fill_in "town_city", with: "Test Please Ignore"
  fill_in "county", with: "Test Please Ignore"
  fill_in "postcode", with: "ZZ99 9ZZ"
  click_button "Continue"
end

When "I fill in my contact details" do
  fill_in "phone_number_calls", with: "07000000000"
  fill_in "phone_number_texts", with: "07000000000"
  fill_in "email", with: "test@example.com"
  click_button "Continue"
end

When "I fill in my nhs number" do
  fill_in "nhs_number", with: "1111111111"
  click_button "Continue"
end
