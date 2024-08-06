# frozen_string_literal: true

require "action_view/model_naming"
require "active_support/core_ext/module/delegation"
require "active_support/string_inquirer"
require "active_support/core_ext/hash/deep_merge"
require "active_support/core_ext/string/inflections"

module Phlexi
  module Form
    # A form component for building flexible and customizable forms.
    #
    # @example Basic usage
    #   Phlexi::Form.new(user, action: '/users', method: 'post') do |f|
    #     render field(:name).placeholder("Name").input_tag
    #     render field(:email).placeholder("Email").input_tag
    #   end
    #
    # @attr_reader [Symbol] key The form's key, derived from the record or explicitly set
    # @attr_reader [ActiveModel::Model, nil] object The form's associated object
    class Base < COMPONENT_BASE
      include ActionView::ModelNaming

      class Namespace < Structure::Namespace; end

      class FieldBuilder < Structure::FieldBuilder; end

      class << self
        def inherited(subclass)
          subclass.const_set(:Namespace, Class.new(self::Namespace)) unless subclass.const_defined?(:Namespace)
          subclass.const_set(:FieldBuilder, Class.new(self::FieldBuilder)) unless subclass.const_defined?(:FieldBuilder)
          super
        end
      end

      attr_reader :key, :object

      delegate :field, :submit_button, :nest_one, :nest_many, to: :@namespace

      # Initializes a new Form instance.
      #
      # @param record [ActiveModel::Model, Symbol, String] The form's associated record or key
      # @param action [String, nil] The form's action URL
      # @param method [String, nil] The form's HTTP method
      # @param attributes [Hash] Additional HTML attributes for the form tag
      # @param options [Hash] Additional options for form configuration
      # @option options [String] :class CSS classes for the form
      # @option options [Class] :namespace_klass Custom namespace class
      # @option options [Class] :builder_klass Custom field builder class
      def initialize(record, action: nil, method: nil, attributes: {}, **options)
        @form_action = action
        @form_method = method
        @form_class = options.delete(:class)
        @attributes = attributes
        @namespace_klass = options.delete(:namespace_klass) || default_namespace_klass
        @builder_klass = options.delete(:builder_klass) || default_builder_klass
        @options = options

        initialize_object_and_key(record)
        initialize_namespace
        initialize_attributes
      end

      # Renders the form template.
      #
      # @return [void]
      def view_template
        form_tag { form_template }
      end

      # Executes the form's content block.
      # Override this in subclasses to defie a static form.
      #
      # @return [void]
      def form_template
        instance_exec(&@_content_block) if @_content_block
      end

      # Renders the form tag with its contents.
      #
      # @yield The form's content
      # @return [void]
      def form_tag(&)
        form(**form_attributes) do
          render_hidden_method_field
          render_authenticity_token if authenticity_token?
          yield
        end
      end

      def extract_input(params)
        call unless @_rendered
        @namespace.extract_input(params)
      end

      protected

      attr_reader :options, :attributes, :namespace_klass, :builder_klass

      # Initializes the object and key based on the given record.
      #
      # @param record [ActiveModel::Model, Symbol, String] The form's associated record or key
      # @return [void]
      def initialize_object_and_key(record)
        # always pop these keys
        # add support for `as` to make it more rails friendly
        @key = options.delete(:key) || options.delete(:as)

        case record
        when String, Symbol
          @object = nil
          @key = record
        else
          @object = convert_to_model(record)
          if @key.nil?
            unless object.respond_to?(:model_name) && object.model_name.respond_to?(:param_key) && object.model_name.param_key.present?
              raise ArgumentError, "record must respond to #model_name.param_key with a non nil value or set `key` option e.g. Phlexi::Form(record, key: :record)"
            end
            @key = object.model_name.param_key
          end
        end
        @key = @key.to_sym
      end

      # Initializes the namespace for the form.
      #
      # @return [void]
      def initialize_namespace
        @namespace = namespace_klass.root(key, object: object, builder_klass: builder_klass)
      end

      # Initializes form attributes.
      #
      # @return [void]
      def initialize_attributes
        attributes[:accept_charset] ||= "UTF-8"
      end

      # Determines the form's action URL.
      #
      # @return [String, nil] The form's action URL
      def form_action
        puts ""
        # if @form_action != false
        #   @form_action ||= if options[:format].nil?
        #     polymorphic_path(object, {})
        #   else
        #     polymorphic_path(object, format: options[:format])
        #   end
        # end
        @form_action
      end

      # Determines the form's HTTP method.
      #
      # @return [ActiveSupport::StringInquirer] The form's HTTP method
      def form_method
        @form_method ||= (object_form_method || "get").to_s.downcase
        ActiveSupport::StringInquirer.new(@form_method)
      end

      # Retrieves the form's CSS classes.
      #
      # @return [String] The form's CSS classes
      def form_class
        # @form_class || "flex flex-col space-y-6 px-4 py-2"
        @form_class
      end

      # Checks if the authenticity token should be included.
      #
      # @return [Boolean] True if the authenticity token should be included, false otherwise
      def authenticity_token?
        defined?(helpers) && options.fetch(:authenticity_token) { !form_method.get? }
      end

      # Retrieves the authenticity token.
      #
      # @return [String] The authenticity token
      def authenticity_token
        options.fetch(:authenticity_token) { helpers.form_authenticity_token }
      end

      # Renders the authenticity token field.
      #
      # @param name [String] The name attribute for the authenticity token field
      # @param value [String] The value for the authenticity token field
      # @return [void]
      def authenticity_token_field(name = "authenticity_token", value = authenticity_token)
        input(name: name, value: value, type: "hidden", hidden: true)
      end

      # Determines the appropriate form method based on the object's state.
      #
      # @return [String, nil] The appropriate form method
      def object_form_method
        if object.respond_to?(:persisted?)
          object.persisted? ? "patch" : "post"
        elsif object.present?
          "post"
        end
      end

      # Renders the hidden method field for non-standard HTTP methods.
      #
      # @return [void]
      def render_hidden_method_field
        return if standard_form_method?
        input(name: "_method", value: form_method, type: "hidden", hidden: true)
      end

      # Checks if the form method is standard (GET or POST).
      #
      # @return [Boolean] True if the form method is standard, false otherwise
      def standard_form_method?
        form_method.get? || form_method.post?
      end

      # Returns the standardized form method for the HTML form tag.
      #
      # @return [String] The standardized form method
      def standardized_form_method
        standard_form_method? ? form_method : "post"
      end

      # Generates the form attributes hash.
      #
      # @return [Hash] The form attributes
      def form_attributes
        {
          id: @namespace.dom_id,
          action: form_action,
          method: standardized_form_method,
          class: form_class,
          **attributes
        }
      end

      # Renders the authenticity token if required.
      #
      # @return [void]
      def render_authenticity_token
        authenticity_token_field
      end

      private

      def default_namespace_klass
        self.class::Namespace
      end

      def default_builder_klass
        self.class::FieldBuilder
      end
    end
  end
end
