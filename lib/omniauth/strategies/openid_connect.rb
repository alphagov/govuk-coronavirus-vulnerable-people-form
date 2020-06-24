# frozen_string_literal: true

require "omniauth"
require "openid_connect"
require "forwardable"
require "json/jwt"

module OmniAuth
  module Strategies
    class OIDC
      include OmniAuth::Strategy
      extend Forwardable

      def_delegator :request, :params

      option :name, "oidc"
      option(:client_options, identifier: nil,
                              redirect_uri: nil,
                              scheme: "https",
                              host: nil,
                              port: 443,
                              authorization_endpoint: "/authorize",
                              token_endpoint: "/token",
                              userinfo_endpoint: "/userinfo",
                              jwks_uri: "/.well-known/jwks.json")
      option :issuer
      option :client_pem_signing_key_path
      option :scope, [:openid]
      option :state
      option :display, nil # [:page, :touch]
      option :prompt, nil # [:none, :login]
      option :send_nonce, true
      option :extra_authorize_params, {}

      def request_phase
        redirect authorize_uri
      end

      def callback_phase
        error = params["error_reason"] || params["error"]
        error_description = params["error_description"] || params["error_reason"]
        invalid_state = params["state"].to_s.empty? || params["state"] != stored_state

        raise CallbackError, error: params["error"], reason: error_description, uri: params["error_uri"] if error
        raise CallbackError, error: :csrf_detected, reason: "Invalid 'state' parameter" if invalid_state

        options.issuer = issuer if options.issuer.blank?

        client.authorization_code = authorization_code
        access_token
        super
      rescue CallbackError => e
        fail!(e.error, e)
      rescue ::Rack::OAuth2::Client::Error => e
        fail!(e.response[:error], e)
      rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
        fail!(:timeout, e)
      rescue ::SocketError => e
        fail!(:failed_to_connect, e)
      end

      def uid
        user_info_raw["sub"]
      end

      info do
        prune!({
          "surname" => user_info_raw["family_name"],
          "first_name" => user_info_raw["given_name"],
          "email" => user_info_raw["email"],
          "phone_number" => user_info_raw["phone_number"],
          "date_of_birth" => user_info_raw["birthdate"],
          "nhs_number" => user_info_raw["nhs_number"],
          "gp_integration_credentials" => user_info_raw["gp_integration_credentials"],
          "gp_registration_details" => user_info_raw["gp_registration_details"],
          "identity_proofing_level" => user_info_raw["identity_proofing_level"],
        })
      end

      extra do
        { raw_info: user_info_raw }
      end

      credentials do
        {
          id_token: access_token.id_token,
          token: access_token.access_token,
          refresh_token: access_token.refresh_token,
          expires_in: access_token.expires_in,
          scope: access_token.scope,
        }
      end

    private

      def client_options
        options.client_options
      end

      def redirect_uri
        return client_options.redirect_uri unless params["redirect_uri"]

        "#{client_options.redirect_uri}?redirect_uri=#{CGI.escape(params['redirect_uri'])}"
      end

      def client
        @client ||= ::OpenIDConnect::Client.new(client_options)
      end

      def authorize_uri
        client.redirect_uri = redirect_uri
        opts = {
          response_type: "code",
          response_mode: "query",
          scope: options.scope,
          state: new_state,
          prompt: options.prompt,
          nonce: (new_nonce if options.send_nonce),
        }

        opts.merge!(options.extra_authorize_params) unless options.extra_authorize_params.empty?

        client.authorization_uri(opts.reject { |_k, v| v.nil? })
      end

      def new_state
        state = if options.state.respond_to?(:call)
                  if options.state.arity == 1
                    options.state.call(env)
                  else
                    options.state.call
                  end
                end
        session["omniauth.state"] = state || SecureRandom.hex(16)
      end

      def stored_state
        session.delete("omniauth.state")
      end

      def new_nonce
        session["omniauth.nonce"] = SecureRandom.hex(16)
      end

      def stored_nonce
        session.delete("omniauth.nonce")
      end

      def session
        return {} if @env.nil?

        super
      end

      def authorization_code
        params["code"]
      end

      def access_token
        return @access_token if @access_token

        private_key = OpenSSL::PKey::RSA.new File.read options.client_pem_signing_key_path

        client_assertion = JSON::JWT.new(
          iss: client_options.identifier,
          sub: client_options.identifier,
          aud: "#{client_options.scheme}://#{client_options.host}#{client_options.token_endpoint}",
          jti: SecureRandom.hex(16),
          iat: Time.zone.now,
          exp: 5.minutes.from_now,
        ).sign(private_key, "RS512").to_s

        @access_token = client.access_token!(
          client_auth_method: "jwt_bearer",
          client_assertion: client_assertion,
        )

        @access_token
      end

      def user_info_raw
        return @user_info if @user_info

        @user_info = access_token.userinfo!.raw_attributes
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      class CallbackError < StandardError
        attr_accessor :error, :error_reason, :error_uri

        def initialize(data)
          self.error = data[:error]
          self.error_reason = data[:reason]
          self.error_uri = data[:uri]
        end

        def message
          [error, error_reason, error_uri].compact.join(" | ")
        end
      end
    end
  end
end

OmniAuth.config.add_camelization "openid_connect", "OIDC"
