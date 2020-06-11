# typed: false
RSpec.describe "coronavirus_form/name" do
  before do
    allow(view).to receive(:previous_path).and_return("/")
  end

  context "when form fields have already been provided" do
    it "shows the filled in fields" do
      name = {
        first_name: "Harry",
        middle_name: "",
        last_name: "Potter",
      }
      assign(:form_responses, name: name)

      render
      name.values.each do |txt|
        expect(rendered).to have_selector("input[value='#{txt}']")
      end
    end
  end
end
