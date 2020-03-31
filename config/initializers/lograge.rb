Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_options = lambda do |_event|
    { time: Time.zone.now }
  end
end
