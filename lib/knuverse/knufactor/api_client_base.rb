module KnuVerse
  module Knufactor
    # The API Client Base class
    class APIClientBase
      attr_reader :server, :base_uri
      attr_accessor :apikey, :secret, :account

      include Validations::APIClient
      include Helpers::APIClient

      def about_service
        get 'about'
      end

      def api_uri
        @api_uri ||= URI.parse(server)
        @api_uri.path = base_uri
        @api_uri
      end

      def authenticated?
        raise Exceptions::APIClientNotConfigured unless configured?
        @auth_token && @last_auth && ((Time.now.utc - @last_auth) < 60) ? true : false
      end

      def configured?
        @configured ? true : false
      end

      def json_headers
        base = { content_type: :json, accept: :json }
        authenticated? ? base.merge(authorization: auth_header) : base
      end

      def refresh_auth_bearer
        auth_data = {
          key_id: @apikey,
          secret: @secret
        }
        resp = post('auth', auth_data)
        resp['jwt']
      end

      def refresh_auth
        @auth_token = refresh_auth_bearer
        @last_auth  = Time.now.utc
        true
      end

      def get(uri, data = nil)
        refresh_auth unless authenticated?

        client_action do |client|
          if data
            JSON.parse client[uri].get(json_headers.merge(params: data))
          else
            JSON.parse client[uri].get(json_headers)
          end
        end
      end

      def post(uri, data = nil)
        refresh_auth unless authenticated? || uri == 'auth'

        client_action do |client|
          if data
            JSON.parse client[uri].post(json_escape(data.to_json), json_headers)
          else
            JSON.parse client[uri].post(nil, json_headers)
          end
        end
      end

      def patch(uri, data)
        refresh_auth unless authenticated?

        client_action do |client|
          response = client[uri].patch(json_escape(data.to_json), json_headers)
          if response && !response.empty?
            JSON.parse(response)
          else
            true
          end
        end
      end

      def put(uri, data)
        refresh_auth unless authenticated?

        client_action do |client|
          client[uri].put(json_escape(data.to_json), json_headers)
        end
      end

      private

      def auth_header
        authenticated? ? "Bearer #{@auth_token}" : nil
      end

      def client_action
        raise Exceptions::APIClientNotConfigured unless configured?
        yield connection
      end

      # Don't bother creating a connection until we need one
      def connection
        @connection ||= RestClient::Resource.new(api_uri.to_s)
      end
    end
  end
end
