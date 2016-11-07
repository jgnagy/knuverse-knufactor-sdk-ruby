module KnuVerse
  module Knufactor
    module Helpers
      # Simple helper class methods for Resource
      module ResourceClass
        # ActiveRecord ActiveModel::Name compatibility method
        def human
          i18n_key.humanize
        end

        # Check if a resource class is immutable
        def immutable?
          @immutable ||= false
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def i18n_key
          name.split('::').last.to_underscore
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def param_key
          singular_route_key.to_sym
        end

        def properties
          @properties ||= {}
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def route_key
          singular_route_key.en.plural
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def singular_route_key
          i18n_key
        end
      end
    end
  end
end
