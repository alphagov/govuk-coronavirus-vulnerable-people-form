if defined?(AssetSync)
  AssetSync.configure do |config|
    config.enabled = false if ENV["HEROKU_APP_NAME"]
    config.fog_provider = "AWS"
    config.fog_region = "eu-west-2"
    config.fog_directory = ENV["AWS_ASSETS_BUCKET_NAME"]
    config.aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    config.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]

    # Don't delete files from the store
    config.existing_remote_files = "keep"
  end
end
