module KnuVerse
  module Knufactor
    # The API Client Singleton class
    class APIClient < APIClientBase
      include Singleton

      def self.configure(opts = {})
        instance.configure(opts)
      end

      def self.about_service
        instance.about_service
      end

      def configure(opts = {})
        # validations
        validate_opts(opts)

        # Set up the client's state
        @server     = opts[:server] || 'https://cloud.knuverse.com'
        @apikey     = opts[:apikey]
        @secret     = opts[:secret]
        @base_uri   = opts[:base_uri] || '/api/v1/'
        @last_auth  = nil
        @auth_token = nil
        @configured = true
      end
    end
  end
end
