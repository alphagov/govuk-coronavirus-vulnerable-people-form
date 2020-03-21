# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  # Start page
  get "/", to: "start#show"

  # Question pages

  # Check answers page
  get "check-your-answers" => "check_answers#show"
  post "check-your-answers" => "check_answers#submit"
end
