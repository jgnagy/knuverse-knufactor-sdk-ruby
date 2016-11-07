module KnuVerse
  module Knufactor
    module Helpers
      # Simple helper class methods for Resource
      module ResourceClass
        # Produce a more human-readable representation of {#i18n_key}
        # @note ActiveRecord ActiveModel::Name compatibility method
        # @return [String]
        def human
          i18n_key.humanize
        end

        # Check if a resource class is immutable
        def immutable?
          @immutable ||= false
        end

        # A mock internationalization key based on the class name
        # @note ActiveRecord ActiveModel::Name compatibility method
        # @return [String]
        def i18n_key
          name.split('::').last.to_underscore
        end

        alias singular_route_key i18n_key

        # A symbolized version of {#i18n_key}
        # @note ActiveRecord ActiveModel::Name compatibility method
        # @return [Symbol]
        def param_key
          i18n_key.to_sym
        end

        # All the properties defined for this Resource class
        # @return [Hash{Symbol => Hash}]
        def properties
          @properties ||= {}
        end

        # A route key for building URLs
        # @note ActiveRecord ActiveModel::Name compatibility method
        # @return [String]
        def route_key
          i18n_key.en.plural
        end
      end
    end
  end
end
