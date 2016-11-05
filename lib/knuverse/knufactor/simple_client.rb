module KnuVerse
  module Knufactor
    # The Simple API Client class
    class SimpleClient < ClientBase
      def initialize(opts = {})
        # validations
        validate_opts(opts)

        # Set up the client's state
        @server     = opts[:server] || 'https://cloud.knuverse.com'
        @apikey     = opts[:apikey]
        @secret     = opts[:secret]
        @account    = opts[:account]
        @base_uri   = opts[:base_uri] || '/api/v1/'
        @last_auth  = nil
        @auth_token = nil
        @configured = true
      end
    end
  end
end
