VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr"
  config.hook_into :webmock
  config.filter_sensitive_data("<ORDNANCE_SURVEY_PLACES_API_KEY>") { ENV["ORDNANCE_SURVEY_PLACES_API_KEY"] }
end
