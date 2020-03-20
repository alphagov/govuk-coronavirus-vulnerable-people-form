# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/healthcheck', to: proc { [200, {}, ['OK']] }

  # Start page
  get '/', to: 'coronavirus_form/start#show'

  # Question pages
  get '/coronavirus-form/medical-equipment' => 'coronavirus_form/medical_equipment#show'
  post '/coronavirus-form/medical-equipment' => 'coronavirus_form/medical_equipment#submit'

  get '/coronavirus-form/medical-equipment-kind' => 'coronavirus_form/medical_equipment_kind#show'
  post '/coronavirus-form/medical-equipment-kind' => 'coronavirus_form/medical_equipment_kind#submit'

  get '/coronavirus-form/hotel-rooms' => 'coronavirus_form/hotel_rooms#show'
  post '/coronavirus-form/hotel-rooms' => 'coronavirus_form/hotel_rooms#submit'

  get '/coronavirus-form/which-goods' => 'coronavirus_form/which_goods#show'
  post '/coronavirus-form/which-goods' => 'coronavirus_form/which_goods#submit'

  get '/coronavirus-form/which-services' => 'coronavirus_form/which_services#show'
  post '/coronavirus-form/which-services' => 'coronavirus_form/which_services#submit'

  # Check answers page
  get '/coronavirus-form/check-your-answers' => 'coronavirus_form/check_answers#show'
  post '/coronavirus-form/check-your-answers' => 'coronavirus_form/check_answers#submit'

  # Final page
  get '/coronavirus-form/thank-you' => 'coronavirus_form/thank_you#show'
end
