module KnuVerse
  module Knufactor
    module Validations
      # APIClient validation methods
      module APIClient
        def validate_creds(opts, exception)
          raise(exception, 'Must Provide Auth') unless opts.key?(:apikey) && opts.key?(:secret)
        end

        # Validate the options passed on initialize
        def validate_opts(opts)
          e = Exceptions::InvalidOptions
          raise(e, 'Is not Hash-like') unless opts.respond_to?(:[]) && opts.respond_to?(:key?)
          validate_server(opts[:server])
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
          return true unless name # if no name is provided, just go with the defaults
          valid = name.is_a? String
          begin
            u = URI.parse(name)
            valid = false unless u.class == URI::HTTP || u.class == URI::HTTPS
          rescue URI::InvalidURIError
            valid = false
          end
          valid || raise(Exceptions::InvalidOptions, 'Invalid server')
        end
      end
    end
  end
end
