# frozen_string_literal: true

if Rails.version >= "6.1" && Rails.application.config.respond_to?(:feature_policy)
  Rails.application.config.feature_policy do |policy|
    policy.geolocation   :none
    policy.midi          :none
    policy.notifications :none
    policy.push          :none
    policy.sync_xhr      :none
    policy.microphone    :self
    policy.camera        :none
    policy.magnetometer  :none
    policy.gyroscope     :none
    policy.speaker       :self
    # policy.vibrate       :self
    policy.fullscreen    :self
    policy.payment       :none
  end
end
