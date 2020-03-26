require "spec_helper"

RSpec.describe AnswersHelper, type: :helper do
  describe "#concat_answer" do
    it "returns the answer if the answer is a string" do
      question = "questions"
      answer = "answer"
      expect(helper.concat_answer(answer, question)).to eq(answer)
    end

    context "contact_details" do
      let(:question) { "contact_details" }

      it "concatenates contact_details with a line break" do
        answer = {
          "phone_number_calls" => "012101234567",
          "phone_number_texts" => "0777001234567",
          "email" => "me@example.com",
        }

        expected_answer =
          "Phone number: #{answer['phone_number_calls']}<br>Text: #{answer['phone_number_texts']}<br>Email: #{answer['email']}"

        expect(helper.concat_answer(answer, question)).to eq(expected_answer)
      end

      it "returns nothing if the contact details are empty" do
        answer = {}

        expect(helper.concat_answer(answer, question)).to be_empty
      end

      it "only concatenates the fields that have a value" do
        answer = {
          "email" => "me@example.com",
        }

        expected_answer = "Email: #{answer['email']}"
        expect(helper.concat_answer(answer, question)).to eq(expected_answer)
      end
    end

    context "support_address" do
      let(:question) { "support_address" }

      it "concatenates support_address with a comma and a line break" do
        answer = {
          "building_and_street_line_1" => "The building",
          "building_and_street_line_2" => "1 High Street",
          "town_city" => "Town",
          "county" => "County",
          "postcode" => "E1 8QS",
        }

        expected_answer =
          "The building,<br>1 High Street,<br>Town,<br>County,<br>E1 8QS"

        expect(helper.concat_answer(answer, question)).to eq(expected_answer)
      end

      it "returns nothing if the support_address is empty" do
        answer = {}

        expect(helper.concat_answer(answer, question)).to be_empty
      end

      it "only concatenates the fields that have a value" do
        answer = {
          "building_and_street_line_1" => "The building",
          "town_city" => "Town",
          "postcode" => "E1 8QS",
        }

        expected_answer = "The building,<br>Town,<br>E1 8QS"
        expect(helper.concat_answer(answer, question)).to eq(expected_answer)
      end
    end
  end
end
