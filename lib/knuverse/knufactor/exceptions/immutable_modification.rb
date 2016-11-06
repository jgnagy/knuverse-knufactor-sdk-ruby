module KnuVerse
  module Knufactor
    module Exceptions
      # Provided when an attempt is made to modify an immutable resource
      class ImmutableModification < APIException
      end
    end
  end
end
