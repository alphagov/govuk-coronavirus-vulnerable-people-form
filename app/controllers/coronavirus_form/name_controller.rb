# frozen_string_literal: true

class CoronavirusForm::NameController < ApplicationController
  def submit
    @form_responses = {
      name: {
        first_name: strip_tags(params[:first_name]&.strip).presence,
        middle_name: strip_tags(params[:middle_name]&.strip).presence,
        last_name: strip_tags(params[:last_name]&.strip).presence,
      },
    }

    invalid_fields = validate_text_fields(%i[first_name last_name], controller_name)

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      session[:name] = @form_responses[:name]
      redirect_to check_your_answers_url
    else
      session[:name] = @form_responses[:name]
      redirect_to date_of_birth_url
    end
  end

private

  def validate_text_fields(mandatory_fields, page)
    mandatory_fields.each_with_object([]) do |field, invalid_fields|
      next if @form_responses[:name].dig(field).present?

      invalid_fields << { field: field.to_s,
                          text: t("coronavirus_form.questions.#{page}.#{field}.custom_error",
                                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.questions.#{page}.#{field}.label")).humanize) }
    end
  end

  def previous_path
    medical_conditions_path
  end
end
