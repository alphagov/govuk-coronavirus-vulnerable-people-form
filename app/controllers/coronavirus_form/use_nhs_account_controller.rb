class CoronavirusForm::UseNhsAccountController < ApplicationController
  skip_before_action :check_first_question

  def show
    reset_session
    super
  end

  def submit
    @form_responses = {
      use_nhs_account: strip_tags(params[:use_nhs_account]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:use_nhs_account],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif @form_responses[:use_nhs_account] == I18n.t("coronavirus_form.preamble.use_nhs_account.options.option_no.label")
      session[:use_nhs_account] = @form_responses[:use_nhs_account]
      redirect_to live_in_england_url
    else
      session[:use_nhs_account] = @form_responses[:use_nhs_account]
      redirect_to "/auth/oidc"
    end
  end

private

  def previous_path
    "/"
  end
end
