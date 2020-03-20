# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoronavirusForm::WhichGoodsController, type: :controller do
  let(:current_template) { 'coronavirus_form/which_goods' }
  let(:session_key) { :which_goods }

  describe 'GET show' do
    it 'renders the form' do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe 'POST submit' do
    let(:selected) { ['Medical equipment', 'Hotel rooms'] }

    it 'sets session variables' do
      post :submit, params: { which_goods: selected }

      expect(session[session_key]).to eq selected
    end

    it 'redirects to next step' do
      post :submit, params: { which_goods: selected }

      expect(response).to redirect_to('/coronavirus-form/which-services')
    end

    it 'redirects to check your answers if check your answers previously seen' do
      session[:check_answers_seen] = true
      post :submit, params: { which_goods: selected }

      expect(response).to redirect_to('/coronavirus-form/check-your-answers')
    end

    it 'validates any option is chosen' do
      post :submit, params: { which_goods: [] }

      expect(response).to render_template(current_template)
    end

    it 'validates a valid option is chosen' do
      post :submit, params: { which_goods: ['<script></script', 'invalid option', 'Medical equipment'] }

      expect(response).to render_template(current_template)
    end
  end
end
