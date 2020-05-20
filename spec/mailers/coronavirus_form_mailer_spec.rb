RSpec.describe CoronavirusFormMailer, type: :mailer do
  describe "#confirmation_email" do
    let(:mail) { CoronavirusFormMailer.with(params).confirmation_email(to_address) }
    let(:to_address) { "user@example.org" }
    let(:reference_number) { "ABC123" }
    let(:params) do
      {
        first_name: "John",
        last_name: "Smith",
        reference_number: reference_number,
        contact_gp: false,
      }
    end

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("emails.confirmation.subject"))
      expect(mail.to).to eq([to_address])
      expect(mail.from).to eq(["test@example.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Dear #{params.dig(:first_name)} #{params.dig(:last_name)}")
      expect(mail.body.encoded.squish).to include(I18n.t("emails.confirmation.no_further_action.body_text", reference_number: reference_number).squish)
    end

    it "renders alternate body text" do
      params = {
        first_name: "John",
        last_name: "Smith",
        reference_number: reference_number,
        contact_gp: true,
      }

      mail = CoronavirusFormMailer.with(params).confirmation_email(to_address)

      expect(mail.body.encoded.squish).to include(I18n.t("emails.confirmation.contact_gp.body_text", reference_number: reference_number).squish)
    end

    it "includes the reference" do
      expect(mail.body.encoded).to include(params.dig(:reference_number))
    end
  end

  describe "#confirmation_sms" do
    let(:mail) { CoronavirusFormMailer.with(params).confirmation_sms(to_number) }
    let(:to_number) { "07700900000" }
    let(:params) { { first_name: "John", last_name: "Smith", reference_number: "ABC123" } }

    it "renders the headers" do
      expect(mail.to).to eq([to_number])
    end

    it "renders the body" do
      expect(mail.body.encoded.squish).to include(I18n.t("sms.confirmation.no_further_action.body_text", first_name: "John", last_name: "Smith").squish)
    end
  end
end
