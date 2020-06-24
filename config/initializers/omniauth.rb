# # frozen_string_literal: true

module OmniAuth
  module Strategies
    autoload :OIDC, Rails.root.join("lib/omniauth/strategies/openid_connect")
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :OIDC,
    scope: ENV["SCOPES"],
    issuer: ENV["ISSUER"],
    extra_authorize_params: { "vtr" => ENV["VTR"] },
    client_pem_signing_key_path: "private_key.pem",
    client_options: {
      host: ENV["ISSUER"],
      redirect_uri: ENV["REDIRECT_URL"],
      identifier: ENV["CLIENT_ID"],
    },
  )
end

