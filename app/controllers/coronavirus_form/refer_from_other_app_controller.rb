# frozen_string_literal: true

class CoronavirusForm::ReferFromOtherAppController < ApplicationController
  def from_find_support_app
    ## Sets the session variables that the user would have already answered in Support app
    session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
    session[:nhs_letter] = I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
    session[:medical_conditions] = I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_medical.label")
    # TODO: this may need to be a POST request since the medical conditions question has multiple "yes" responses

    # Redirect to next question
    redirect_to name_url
  end
end
