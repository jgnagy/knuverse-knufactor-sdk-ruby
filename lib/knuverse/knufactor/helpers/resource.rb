module KnuVerse
  module Knufactor
    module Helpers
      # Simple helper methods for Resources
      module Resource
        def datetime_from_params(params, actual_key)
          DateTime.new(
            params["#{actual_key}(1i)"].to_i,
            params["#{actual_key}(2i)"].to_i,
            params["#{actual_key}(3i)"].to_i,
            params["#{actual_key}(4i)"].to_i,
            params["#{actual_key}(5i)"].to_i
          )
        end

        def fresh?
          !tainted?
        end

        def id_property
          self.class.properties.select { |_, opts| opts[:id_property] }.keys.first
        end

        def id
          @entity[id_property.to_s]
        end

        def immutable?
          self.class.immutable?
        end

        # ActiveRecord ActiveModel::Name compatibility method
        def model_name
          self.class
        end

        def new?
          !@entity.key?(id_property.to_s)
        end

        def paths
          self.class.paths
        end

        def path_for(kind)
          self.class.path_for(kind)
        end

        # ActiveRecord ActiveModel::Model compatibility method
        def persisted?
          !new?
        end

        def tainted?
          @tainted ? true : false
        end

        # ActiveRecord ActiveModel::Conversion compatibility method
        def to_key
          new? ? [] : [id]
        end

        # ActiveRecord ActiveModel::Conversion compatibility method
        def to_model
          self
        end

        # ActiveRecord ActiveModel::Conversion compatibility method
        def to_param
          new? ? nil : id.to_s
        end

        # ActiveRecord ActiveModel compatibility method
        def update(params)
          new_params = {}
          # need to convert multi-part datetime params
          params.each do |key, value|
            if key =~ /([^(]+)\(1i/
              actual_key = key.match(/([^(]+)\(/)[1]
              new_params[actual_key] = datetime_from_params(params, actual_key)
            else
              new_params[key] = value
            end
          end

          new_params.each do |key, value|
            setter_key = "#{key}=".to_sym
            raise Exceptions::InvalidProperty unless respond_to?(setter_key)
            send(setter_key, value)
          end
          save
        end
      end
    end
  end
end
