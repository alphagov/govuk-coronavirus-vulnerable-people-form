RSpec.describe CoronavirusFormMailer, type: :mailer do
  describe "#confirmation_email" do
    let(:mail) { CoronavirusFormMailer.with(params).confirmation_email(to_address) }
    let(:to_address) { "user@example.org" }
    let(:params) { { first_name: "John", last_name: "Smith" } }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("emails.confirmation.subject"))
      expect(mail.to).to eq([to_address])
      expect(mail.from).to eq(["test@example.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Dear #{params.dig(:first_name)} #{params.dig(:last_name)}")
    end
  end
end
