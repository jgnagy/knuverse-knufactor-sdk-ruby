module KnuVerse
  module Knufactor
    # Validation methods
    module ClientValidations
      def validate_creds(opts, exception)
        auth_by_cred = valid_user_creds(opts)
        auth_by_key  = valid_key_creds(opts)
        raise(exception, 'Must Auth Using Key or Username') unless auth_by_cred || auth_by_key
        raise(exception, 'Key and User Auth Are Mutually Exclusive') if auth_by_cred && auth_by_key
      end

      def valid_user_creds(opts)
        opts.key?(:username) && opts.key?(:password) ? true : false
      end

      def valid_key_creds(opts)
        opts.key?(:key_id) && opts.key?(:secret) ? true : false
      end

      # Validate the options passed on initialize
      def validate_opts(opts)
        e = Exceptions::InvalidOptions
        raise(e, 'Is not Hash-like') unless opts.respond_to?(:[]) && opts.respond_to?(:key?)
        raise(e, 'Missing account') unless opts.key?(:account)
        if opts.key?(:base_uri)
          begin
            URI.parse(opts[:base_uri])
          rescue URI::InvalidURIError => e
            raise(e, "Invalid base_uri: #{e}")
          end
        end

        validate_creds(opts, e)
        true
      end

      # Validate the server name provided
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
