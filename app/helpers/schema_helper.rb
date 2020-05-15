module SchemaHelper
  FORM_RESPONSE_SCHEMA = File.read(Rails.root.join("config/schemas/form_response.json"))

  def validate_against_form_response_schema(data)
    schema = JSON.parse(FORM_RESPONSE_SCHEMA)
    JSON::Validator.fully_validate(schema, data)
  end
end
