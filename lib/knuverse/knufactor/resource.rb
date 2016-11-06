module KnuVerse
  module Knufactor
    # A generic API resource
    class Resource
      attr_accessor :client
      attr_reader :errors

      include Comparable
      include Validations::Resource
      include Helpers::Resource
      extend Helpers::ResourceClass

      def self.properties
        @properties ||= {}
      end

      # Can this type of resource be changed client-side?
      def self.immutable(status)
        unless status.is_a?(TrueClass) || status.is_a?(FalseClass)
          raise Exceptions::InvalidArguments
        end
        @immutable = status
      end

      # Check if a resource class is immutable
      def self.immutable?
        @immutable ||= false
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
          @entity[name.to_s] = opts[:type] == :time ? Time.parse(value.to_s).utc : value
          @tainted = true
        end
      end

      def self.gen_property_methods
        properties.each do |prop, opts|
          # Getter methods
          next if opts[:id_property]
          gen_getter_method(prop, opts)

          # Setter methods (don't make one for obviously read-only properties)
          next if opts[:read_only]
          gen_setter_method(prop, opts)
        end
      end

      def self.all(options = {})
        # TODO: Add validations for options

        # TODO: add validation checks for the required pieces
        raise Exceptions::MissingPath unless path_for(:all)

        api_client = options[:api_client] || APIClient.instance

        root = name.split('::').last.en.plural.to_underscore
        # TODO: do something with lazy requests...

        #ResourceCollection.new(
          api_client.get(path_for(:all))[root].collect do |record|
            self.new(
              entity: record,
              lazy: (options[:lazy] ? true : false),
              tainted: false,
              api_client: api_client
            )
          #end,
          end
          #type: self,
          #client: options[:client]
        #)
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

      def initialize(options = {})
        # TODO: better options validations
        raise Exceptions::InvalidOptions unless options.is_a?(Hash)

        @entity = options[:entity] || {}

        # Allows lazy-loading if we're told this is a lazy instance
        #  This means only the minimal attributes were fetched.
        #  This shouldn't be set by end-users.
        @lazy    = options.key?(:lazy) ? options[:lazy] : false
        # This allows local, user-created instances to be differentiated from fetched
        # instances from the backend API. This shouldn't be set by end-users.
        @tainted = options.key?(:tainted) ? options[:tainted] : true
        # This is the API Client used to get data for this resource
        @client  = options[:api_client] || APIClient.instance
        @errors  = {}

        validate_mutability
        validate_id

        self.class.class_eval { gen_property_methods }
      end

      def <=>(other)
        if id < other.id
          -1
        elsif id > other.id
          1
        elsif id == other.id
          0
        else
          raise Exceptions::InvalidArguments
        end
      end
    end
  end
end
