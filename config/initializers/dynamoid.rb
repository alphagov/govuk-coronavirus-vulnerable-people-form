require "dynamoid"

Dynamoid.configure do |config|
  # To namespace tables created by Dynamoid from other tables you might have.
  config.namespace = nil
  Rails.configuration.submissions_db_table_name = ENV["AWS_DYNAMODB_SUBMISSIONS_TABLE_NAME"]

  config.access_key = ENV["AWS_ACCESS_KEY_ID"]
  config.secret_key = ENV["AWS_SECRET_ACCESS_KEY"]
  config.region = "eu-west-2"

  unless Rails.env.production?
    # [Optional]. If provided, it communicates with the DB listening at the endpoint - to communication with DynamoDB local.
    config.endpoint = "http://localhost:8000"
    config.access_key = "fakeMyKeyId"
    config.secret_key = "fakeSecretAccessKey"
    if Rails.env.development?
      Rails.configuration.submissions_db_table_name = "coronavirus-vulnerable-people-development"
    elsif Rails.env.test?
      Rails.configuration.submissions_db_table_name = "coronavirus-vulnerable-people-test"
    end
  end
end
