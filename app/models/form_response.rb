class FormResponse
  include Dynamoid::Document

  table name: :'coronavirus-vulnerable-people-local', key: :reference_id
  field :reference_id, :string
  range :unix_timestamp, :datetime

  field :form_response, :map
end
