require "spec_helper"

RSpec.describe I18n, type: :feature do
  context "SMS content" do
    it "all body text is less than or equal to 918 characters" do
      I18n.t("sms").each do |_, sms_type|
        expect(sms_type[:body_text].chomp.length).to be <= 918
      end
    end
  end
end
