# typed: false
RSpec.describe "coronavirus_form/check_contact_details" do
  include FieldValidationHelper

  before do
    allow(view).to receive(:previous_path).and_return("/")
  end

  it "shows an email suggestion when one exists" do
    suggestion = "me@example.com"

    assign(:email_suggestion, suggestion)
    assign(:form_responses, {})

    render
    expect(rendered)
      .to have_content(strip_tags(I18n.t("coronavirus_form.questions.check_contact_details.hint", field: suggestion)))
  end

  it "does not show an email suggestion when one does not exist" do
    suggestion = nil

    assign(:email_suggestion, suggestion)
    assign(:form_responses, {})

    render
    expect(rendered)
      .to_not have_content(strip_tags(I18n.t("coronavirus_form.questions.check_contact_details.hint", field: suggestion)))
  end
end
