module KnuVerse
  module Knufactor
    # The API Client class
    class Client
      attr_reader :server, :base_uri, :account
      attr_accessor :username, :password

      include ClientValidations
      include ClientHelpers

      def initialize(server, opts = {})
        # validations
        validate_opts(opts)
        validate_server(server)

        # Set up the client's state
        @server     = server
        @username   = opts[:username]
        @password   = opts[:password]
        @key_id     = opts[:key_id]
        @secret     = opts[:secret]
        @account    = opts[:account].to_s
        @base_uri   = opts[:base_uri] || '/api/v1/'
        @last_auth  = nil
        @auth_token = nil
      end

      def about_service
        get 'about'
      end

      def api_uri
        @api_uri ||= URI.parse(server)
        @api_uri.path = base_uri
        @api_uri
      end

      def authenticated?
        @auth_token && @last_auth && ((Time.now.utc - @last_auth) < (60 * 15)) ? true : false
      end

      def json_headers
        base = { content_type: :json, accept: :json }
        base.merge(authorization: auth_header) if authenticated?
        base
      end

      def refresh_auth_bearer
        auth_data = {
          account_number: @account,
          user: @username,
          password: @password
        }
        resp = post('auth', auth_data)
        resp['jwt']
      end

      def refresh_auth
        @auth_token = refresh_auth_bearer
        @last_auth  = Time.now.utc
        true
      end

      def using_auth?
        username && password ? true : false
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

      def post(uri, data)
        refresh_auth unless authenticated? || uri == 'auth'

        client_action do |client|
          JSON.parse client[uri].post(json_escape(data.to_json), json_headers)
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
        "Bearer #{@auth_token}"
      end

      def client_action
        yield connection
      end

      # Don't bother creating a connection until we need one
      def connection
        @connection ||= RestClient::Resource.new(api_uri.to_s)
      end
    end
  end
end
