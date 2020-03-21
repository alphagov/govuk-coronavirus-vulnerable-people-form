class FormResponse < ApplicationRecord
  has_kms_key

  encrypts :form_response, type: :json, key: :kms_key
end
