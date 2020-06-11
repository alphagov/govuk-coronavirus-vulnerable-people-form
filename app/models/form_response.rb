# typed: strict
class FormResponse
  include Dynamoid::Document

  table name: Rails.configuration.submissions_db_table_name, key: :ReferenceId
  field :ReferenceId, :string
  range :UnixTimestamp, :datetime

  field :FormResponse, :map
end
