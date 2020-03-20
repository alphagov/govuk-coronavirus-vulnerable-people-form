# frozen_string_literal: true

class CoronavirusForm::WhichGoodsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    session[:which_goods] ||= []
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    which_goods = Array(params[:which_goods]).map { |item| sanitize(item).presence }.compact
    which_goods_other_goods_details = sanitize(params[:which_goods_other_details]).presence

    session[:which_goods] = which_goods
    session[:which_goods_other_details] = which_goods_other_goods_details

    invalid_fields = validate_checkbox_field(
      PAGE,
      values: which_goods,
      allowed_values: I18n.t("coronavirus_form.#{PAGE}.options").map { |_, item| item.dig(:label) },
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    else
      redirect_to controller: session["check_answers_seen"] ? "coronavirus_form/check_answers" : "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "which_goods".freeze
  NEXT_PAGE = "which_services".freeze

  def previous_path
    "/"
  end
end
