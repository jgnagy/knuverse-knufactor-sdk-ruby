module KnuVerse
  module Knufactor
    # A generic API resource
    # TODO: Thread safety
    class Resource
      attr_accessor :client
      attr_reader :errors

      include Comparable
      include Validations::Resource
      include Helpers::Resource
      extend Helpers::ResourceClass

      # Can this type of resource be changed client-side?
      def self.immutable(status)
        unless status.is_a?(TrueClass) || status.is_a?(FalseClass)
          raise Exceptions::InvalidArguments
        end
        @immutable = status
      end

      # Define a property for a model
      # TODO: add more validations on options and names
      def self.property(name, options = {})
        @properties ||= {}

        invalid_prop_names = [
          :>, :<, :'=', :class, :def,
          :%, :'!', :/, :'.', :'?', :*, :'{}',
          :'[]'
        ]

        raise(Exception::InvalidProperty) if invalid_prop_names.include?(name.to_sym)
        @properties[name.to_sym] = options
      end

      # Set the URI path for a resource method
      def self.path(kind, uri)
        paths[kind.to_sym] = uri
      end

      # Create or set a class-level location to store URI paths for methods
      def self.paths
        @paths ||= {}
      end

      def self.path_for(kind)
        paths[kind.to_sym]
      end

      def self.gen_getter_method(name, opts)
        method_name = opts[:type] == :boolean ? "#{name}?" : name
        define_method(method_name.to_sym) do
          name_as_string = name.to_s
          reload if @lazy && !@entity.key?(name_as_string)

          case opts[:type]
          when :time
            if @entity[name_as_string] && !@entity[name_as_string].to_s.empty?
              Time.parse(@entity[name_as_string].to_s).utc
            end
          else
            @entity[name_as_string]
          end
        end
      end

      def self.gen_setter_method(name, opts)
        define_method("#{name}=".to_sym) do |value|
          raise Exceptions::ImmutableModification if immutable?
          # TODO: allow specifying a list of allowed values and validating against it
          @entity[name.to_s] = opts[:type] == :time ? Time.parse(value.to_s).utc : value
          @tainted = true
          @modified_properties << name.to_sym
        end
      end

      def self.gen_property_methods
        properties.each do |prop, opts|
          # Getter methods
          next if opts[:id_property]
          gen_getter_method(prop, opts) unless opts[:write_only]

          # Setter methods (don't make one for obviously read-only properties)
          gen_setter_method(prop, opts) unless opts[:read_only]
        end
      end

      def self.all(options = {})
        # TODO: Add validations for options

        # TODO: add validation checks for the required pieces
        raise Exceptions::MissingPath unless path_for(:all)

        api_client = options[:api_client] || APIClient.instance

        root = name.split('::').last.en.plural.to_underscore
        # TODO: do something with lazy requests...

        ResourceCollection.new(
          api_client.get(path_for(:all))[root].collect do |record|
            new(
              entity: record,
              lazy: (options[:lazy] ? true : false),
              tainted: false,
              api_client: api_client
            )
          end,
          type: self,
          api_client: api_client
        )
      end

      def self.get(id, options = {})
        # TODO: Add validations for options
        raise Exceptions::MissingPath unless path_for(:all)

        api_client = options[:api_client] || APIClient.instance

        new(
          entity: api_client.get("#{path_for(:all)}/#{id}"),
          lazy: false,
          tainted: false,
          api_client: api_client
        )
      end

      def self.where(attribute, value, options = {})
        # TODO: validate incoming options
        options[:comparison] ||= value.is_a?(Regexp) ? :match : '=='
        api_client = options[:api_client] || APIClient.instance
        all(lazy: (options[:lazy] ? true : false), api_client: api_client).where(
          attribute, value, comparison: options[:comparison]
        )
      end

      def initialize(options = {})
        # TODO: better options validations
        raise Exceptions::InvalidOptions unless options.is_a?(Hash)

        @entity = options[:entity] || {}

        # Allows lazy-loading if we're told this is a lazy instance
        #  This means only the minimal attributes were fetched.
        #  This shouldn't be set by end-users.
        @lazy = options.key?(:lazy) ? options[:lazy] : false
        # This allows local, user-created instances to be differentiated from fetched
        # instances from the backend API. This shouldn't be set by end-users.
        @tainted = options.key?(:tainted) ? options[:tainted] : true
        # This is the API Client used to get data for this resource
        @api_client = options[:api_client] || APIClient.instance
        @errors = {}
        # A place to store which properties have been modified
        @modified_properties = []

        validate_mutability
        validate_id

        self.class.class_eval { gen_property_methods }
      end

      def destroy
        raise Exceptions::ImmutableModification if immutable?
        unless new?
          @api_client.delete("#{path_for(:all)}/#{id}")
          @lazy = false
          @tainted = true
          @entity.delete('id')
        end
        true
      end

      def reload
        if new?
          # Can't reload a new resource
          false
        else
          @entity  = @api_client.get("#{path_for(:all)}/#{id}")
          @lazy    = false
          @tainted = false
          true
        end
      end

      def save
        saveable_data = @entity.select do |prop, value|
          pr = prop.to_sym
          go = properties.key?(pr) && !properties[pr][:read_only] && !value.nil?
          @modified_properties.uniq.include?(pr) if go
        end

        if new?
          @entity  = @api_client.post(path_for(:all).to_s, saveable_data)
          @lazy    = true
        else
          @api_client.put("#{path_for(:all)}/#{id}", saveable_data)
        end
        @tainted = false
        true
      end
    end
  end
end
