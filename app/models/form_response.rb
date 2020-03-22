class FormResponse
  include Dynamoid::Document

  table name: Rails.configuration.submissions_db_table_name, key: :reference_id
  field :reference_id, :string
  range :unix_timestamp, :datetime

  field :form_response, :map
end
