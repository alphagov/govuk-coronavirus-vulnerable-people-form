And(/I click the (.*) button$/) do |button|
  click_on button
end

Then(/I can see the (.*) page content$/) do |form_page|
  expect(page).to have_content(I18n.t("coronavirus_form.questions.#{form_page}.title"))
  description = I18n.t("coronavirus_form.questions.#{form_page}.description", default: nil)
  hint = I18n.t("coronavirus_form.questions.#{form_page}.hint", default: nil)
  expect(page).to have_content(hint) if hint
  expect(page).to have_content(description) if description
end

And(/I choose (.*)$/) do |radio_button|
  choose radio_button
end

Then(/I can see the (.*) radio button options$/) do |form_page|
  I18n.t("coronavirus_form.questions.#{form_page}.options").map do |_, item|
    expect(page).to have_content(item[:label])
  end
end
