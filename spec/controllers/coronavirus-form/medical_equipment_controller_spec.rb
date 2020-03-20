# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoronavirusForm::MedicalEquipmentController, type: :controller do
  let(:current_template) { 'coronavirus_form/medical_equipment' }
  let(:session_key) { :medical_equipment }

  describe 'GET show' do
    it 'renders the form' do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe 'POST submit' do
    let(:selected) { "Yes" }

    it 'sets session variables' do
      post :submit, params: { medical_equipment: selected }

      expect(session[session_key]).to eq selected
    end

    it 'redirects to medical equipment kind' do
      post :submit, params: { medical_equipment: selected }

      expect(response).to redirect_to('/coronavirus-form/medical-equipment-kind')
    end

    context "selects no" do
      let(:selected) { "No" }
      it 'redirects to hotel rooms' do
        post :submit, params: { medical_equipment: selected }

        expect(response).to redirect_to('/coronavirus-form/hotel-rooms')
      end
    end

    it 'redirects to check your answers if check your answers previously seen' do
      session[:check_answers_seen] = true
      post :submit, params: { medical_equipment: selected }

      expect(response).to redirect_to('/coronavirus-form/check-your-answers')
    end

    it 'validates the option is set' do
      post :submit, params: { medical_equipment: nil }

      expect(response).to render_template(current_template)
    end

    it 'validates the form key is provided' do
      post :submit
      expect(response).to render_template(current_template)
    end

    it 'validates a valid option is chosen' do
      post :submit, params: { medical_equipment: '<script>alert(1)</script>' }

      expect(response).to render_template(current_template)
    end
  end
end
