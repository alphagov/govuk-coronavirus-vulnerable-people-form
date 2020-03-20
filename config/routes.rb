# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/healthcheck', to: proc { [200, {}, ['OK']] }

  get '/', to: 'coronavirus_form/start#show'

  get "/coronavirus-form/which-goods" => "coronavirus_form/which_goods#show"
  post "/coronavirus-form/which-goods" => "coronavirus_form/which_goods#submit"

  get "/coronavirus-form/which-services" => "coronavirus_form/which_services#show"
  post "/coronavirus-form/which-services" => "coronavirus_form/which_services#submit"

  get "/coronavirus-form/thank-you" => "coronavirus_form/thank_you#show"
end
