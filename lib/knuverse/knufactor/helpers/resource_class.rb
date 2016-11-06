module KnuVerse
  module Knufactor
    module Helpers
      # Simple helper class methods for Resource
      module ResourceClass
        # ActiveRecord ActiveModel::Name compatibility method
        def self.human
          i18n_key.humanize
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def self.i18n_key
          name.split('::').last.to_underscore
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def self.param_key
          singular_route_key.to_sym
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def self.route_key
          singular_route_key.en.plural
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def self.singular_route_key
          i18n_key
        end
      end
    end
  end
end
