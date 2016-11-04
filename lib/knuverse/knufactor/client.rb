module KnuVerse
  module Knufactor
    # The API Client class
    class Client
      attr_reader :server, :base_uri
      attr_accessor :username, :password, :account

      def initialize(server, opts = {})
        # validations
        validate_opts(opts)
        validate_server(server)

        # Set up the client's state
        @server   = server
        @username = opts[:username]
        @password = opts[:password]
        @account  = opts[:account]
        @base_uri = opts[:base_uri] || '/api/v1/'
      end

      def api_uri
        @api_uri ||= URI.parse(server)
        @api_uri.path = base_uri
        @api_uri
      end

      def version
        VERSION
      end

      def using_auth?
        username && password ? true : false
      end

      private

      # Don't bother creating a connection until we need one
      def connection
        @connection ||= Faraday.new(api_uri)
      end

      # Validation methods

      # Validate the options passed on initialize
      def validate_opts(opts)
        e = Exceptions::InvalidOptions
        raise(e, 'Is not Hash-like') unless opts.respond_to?(:[]) && opts.respond_to?(:key?)
        raise(e, 'Missing account') unless opts.key? :account
        if opts.key?(:base_uri)
          begin
            URI.parse(opts[:base_uri])
          rescue URI::InvalidURIError => e
            raise(e, "Invalid base_uri: #{e}")
          end
        end

        true
      end

      def validate_server(name)
        valid = name.is_a? String
        begin
          u = URI.parse(name)
          valid = false unless u.class == URI::HTTP || u.class == URI::HTTPS
        rescue URI::InvalidURIError
          valid = false
        end
        valid || raise(Exceptions::InvalidArguments, 'Invalid server')
      end
    end
  end
end
