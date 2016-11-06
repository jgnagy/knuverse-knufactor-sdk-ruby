module KnuVerse
  module Knufactor
    module Validations
      # Resource validation methods
      module Resource
        def validate_mutability
          raise Exceptions::ImmutableModification if immutable? && @tainted # this shouldn't happen
        end

        # The 'id' field should not be set manually
        def validate_id
          raise Exceptions::NewInstanceWithID if @entity.key?('id') && @tainted
        end
      end
    end
  end
end
