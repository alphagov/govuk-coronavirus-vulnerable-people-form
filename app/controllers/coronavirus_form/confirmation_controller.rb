# frozen_string_literal: true

class CoronavirusForm::ConfirmationController < ApplicationController
  skip_before_action :check_first_question

  def show
    @contact_gp = params[:contact_gp]
    super
  end
end
