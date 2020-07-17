# frozen_string_literal: true

class JsonValidator
  attr_reader :schema, :json_data

  def initialize(schema, json_data)
    @schema = schema
    @json_data = json_data.deep_stringify_keys
  end

  def valid?
    validator.valid?(json_data)
  end

  # When a key is missing `JSONSchemer::Schema::Base#validate` returns a "details" key,
  # that contains a description of the failure:
  #
  #   { "missing_keys" => ["name_of_key"] }
  #
  # It also returns a "data" key that's value includes all the submitted data and therefore it
  # should not be included in the error output as that output is to be logged.
  #
  # For other errors such as formatting errors:
  #   - "data" contains only the erroneous input
  #   - "data_pointer" an xpath location of that input within the data
  #   - "schema_pointer" an xpath location of the rule that failed in the schema
  #
  def errors
    @errors ||= error_details.map do |error|
      if error["details"].present?
        error["details"]
      elsif error["data_pointer"].present?
        error.slice("data", "data_pointer", "schema_pointer")
      else
        {
          type: "Unknown error",
          json_data_keys: json_data.keys,
          error_keys: errors.keys,
        }
      end
    end
  end

  def validator
    @validator ||= JSONSchemer.schema(schema)
  end

  def error_details
    validator.validate(json_data).to_a
  end
end
