module KnuVerse
  module Knufactor
    module Helpers
      # Simple helper methods for the API Client
      module APIClient
        def json_escape(s)
          json_escape = {
            '&' => '\u0026',
            '>' => '\u003e',
            '<' => '\u003c',
            '%' => '\u0025',
            "\u2028" => '\u2028',
            "\u2029" => '\u2029'
          }
          json_escape_regex = /[\u2028\u2029&><%]/u

          s.to_s.gsub(json_escape_regex, json_escape)
        end

        def raw
          connection
        end

        def version
          VERSION
        end
      end
    end
  end
end
