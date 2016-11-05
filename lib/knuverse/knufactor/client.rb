module KnuVerse
  module Knufactor
    # The API Client class
    class Client
      attr_reader :server, :base_uri
      attr_accessor :username, :password, :account

      include ClientValidations

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
        @account    = opts[:account]
        @base_uri   = opts[:base_uri] || '/api/v1/'
        @last_auth  = nil
        @auth_token = nil
      end

      def about_service
        connection.get('about')
      end

      def api_uri
        @api_uri ||= URI.parse(server)
        @api_uri.path = base_uri
        @api_uri
      end

      def refresh_auth_bearer
        # TODO: make this do things
      end

      def refresh_auth
        @auth_token = refresh_auth_bearer
        @last_auth  = Time.now.utc
      end

      def using_auth?
        username && password ? true : false
      end

      def version
        VERSION
      end

      private

      # Don't bother creating a connection until we need one
      def connection
        @connection ||= Faraday.new(api_uri) do |faraday|
          faraday.headers[:user_agent] = "#{self.class.name} v#{version}"
          faraday.headers[:content_type] = 'application/json'
        end
      end
    end
  end
end
