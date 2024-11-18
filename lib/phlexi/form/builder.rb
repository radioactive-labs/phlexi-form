# frozen_string_literal: true

module Phlexi
  module Form
    # Builder class is responsible for building form fields with various options and components.
    class Builder < Phlexi::Field::Builder
      include Phlexi::Form::HTML::Behaviour
      include Options::Validators
      include Options::InferredTypes
      include Options::Errors
      include Options::Choices
      include Options::Hints
      include Options::Required
      include Options::Autofocus
      include Options::Disabled
      include Options::Readonly
      include Options::Length
      include Options::Max
      include Options::Min
      include Options::Pattern
      include Options::Limit
      include Options::Step

      class FieldCollection < Phlexi::Form::Structure::FieldCollection; end

      attr_reader :input_attributes

      # Initializes a new Builder instance.
      #
      # @param key [Symbol, String] The key for the field.
      # @param parent [Structure::Namespace] The parent object.
      # @param object [Object, nil] The associated object.
      # @param value [Object] The initial value for the field.
      # @param input_attributes [Hash] Default attributes to apply to input fields.
      # @param options [Hash] Additional options for the field.
      def initialize(*, input_attributes: {}, **)
        super(*, **)

        @input_attributes = input_attributes
      end

      # Creates an input tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the input.
      # @return [Components::Input] The input component.
      def input_tag(theme: :input, **, &)
        create_component(Components::Input, theme, **, &)
      end

      def string_tag(**, &)
        input_tag(type: :text, theme: :string, **, &)
      end

      def number_tag(**, &)
        input_tag(type: :number, theme: :number, **, &)
      end

      def date_tag(**, &)
        input_tag(type: :date, theme: :date, **, &)
      end

      def time_tag(**, &)
        input_tag(type: :time, theme: :time, **, &)
      end

      def datetime_local_tag(**, &)
        input_tag(type: :"datetime-local", theme: :datetime, **, &)
      end
      alias_method :datetime_tag, :datetime_local_tag

      def email_tag(**, &)
        input_tag(type: :email, theme: :email, **, &)
      end

      def password_tag(**, &)
        input_tag(type: :password, theme: :password, **, &)
      end

      def phone_tag(**, &)
        input_tag(type: :tel, theme: :phone, **, &)
      end

      def color_tag(**, &)
        input_tag(type: :color, theme: :color, **, &)
      end

      def url_tag(**, &)
        input_tag(type: :url, theme: :url, **, &)
      end

      def search_tag(**, &)
        input_tag(type: :search, theme: :search, **, &)
      end

      def hidden_input_tag(**, &)
        input_tag(type: :hidden, theme: nil, **, &)
      end
      alias_method :hidden_tag, :hidden_input_tag
      # Creates a checkbox tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the checkbox.
      # @return [Components::Checkbox] The checkbox component.
      def checkbox_tag(**, &)
        create_component(Components::Checkbox, :checkbox, **, &)
      end

      def boolean_tag(**, &)
        checkbox_tag(**, theme: :boolean, &)
      end

      def file_input_tag(**, &)
        create_component(Components::FileInput, :file, **, &)
      end
      alias_method :file_tag, :file_input_tag

      # Creates collection checkboxes for the field.
      #
      # @param attributes [Hash] Additional attributes for the collection checkboxes.
      # @yield [block] The block to be executed for each checkbox.
      # @return [Components::CollectionCheckboxes] The collection checkboxes component.
      def collection_checkboxes_tag(**, &)
        create_component(Components::CollectionCheckboxes, :collection_checkboxes, **, &)
      end

      # Creates a radio button tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the radio button.
      # @return [Components::RadioButton] The radio button component.
      def radio_button_tag(**, &)
        create_component(Components::RadioButton, :radio, **, &)
      end

      # Creates collection radio buttons for the field.
      #
      # @param attributes [Hash] Additional attributes for the collection radio buttons.
      # @yield [block] The block to be executed for each radio button.
      # @return [Components::CollectionRadioButtons] The collection radio buttons component.
      def collection_radio_buttons_tag(**, &)
        create_component(Components::CollectionRadioButtons, :collection_radio_buttons, **, &)
      end

      # Creates a textarea tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the textarea.
      # @return [Components::Textarea] The textarea component.
      def textarea_tag(**, &)
        create_component(Components::Textarea, :textarea, **, &)
      end
      alias_method :text_tag, :textarea_tag

      def hstore_tag(**, &)
        @value = @value.to_s.tr("{}", "")
        textarea_tag(**, theme: :hstore, &)
      end

      # Creates a select tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the select.
      # @return [Components::Select] The select component.
      def select_tag(**, &)
        create_component(Components::Select, :select, **, &)
      end

      def belongs_to_tag(**options, &)
        options.fetch(:input_param) {
          options[:input_param] = if association_reflection.respond_to?(:options) && association_reflection.options[:foreign_key]
            association_reflection.options[:foreign_key]
          else
            :"#{association_reflection.name}_id"
          end
        }
        select_tag(**options, &)
      end

      def polymorphic_belongs_to_tag(**, &)
        # TODO: this requires a grouped_select component
        # see: Plutonium::Core::Fields::Inputs::PolymorphicBelongsToAssociationInput
        raise NotImplementedError, "polymorphic belongs_to associations are not YET supported"
      end

      def has_one_tag(**, &)
        raise NotImplementedError, "has_one associations are NOT supported"
      end

      def has_many_tag(**options, &)
        options.fetch(:input_param) {
          options[:input_param] = :"#{association_reflection.name.to_s.singularize}_ids"
        }

        select_tag(**options, &)
      end
      alias_method :has_and_belongs_to_many_tag, :has_many_tag

      def input_array_tag(**, &)
        create_component(Components::InputArray, :array, **, &)
      end

      # Creates a label tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the label.
      # @return [Components::Label] The label component.
      def label_tag(**, &)
        create_component(Components::Label, :label, **, &)
      end

      # Creates a hint tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the hint.
      # @return [Components::Hint] The hint component.
      def hint_tag(**, &)
        create_component(Components::Hint, :hint, **, &)
      end

      # Creates an error tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the error.
      # @return [Components::Error] The error component.
      def error_tag(**, &)
        create_component(Components::Error, :error, **, &)
      end

      # Creates a full error tag for the field.
      #
      # @param attributes [Hash] Additional attributes for the full error.
      # @return [Components::FullError] The full error component.
      def full_error_tag(**, &)
        create_component(Components::FullError, :full_error, **, &)
      end

      # Wraps the field with additional markup.
      #
      # @param inner [Hash] Attributes for the inner wrapper.
      # @param attributes [Hash] Additional attributes for the wrapper.
      # @yield [block] The block to be executed within the wrapper.
      # @return [Components::Wrapper] The wrapper component.
      def wrapped(inner: {}, **attributes, &)
        attributes = apply_component_theme(attributes, :wrapper)
        inner = apply_component_theme(inner, :inner_wrapper)
        Components::Wrapper.new(self, inner: inner, **attributes, &)
      end

      # Creates a submit button
      #
      # @param attributes [Hash] Additional attributes for the submit.
      # @return [Components::SubmitButton] The submit button component.
      def submit_button_tag(**, &)
        create_component(Components::SubmitButton, :submit_button, **, &)
      end

      def extract_input(params)
        raise "field##{dom.name} did not define an input component" unless @field_input_extractor

        @field_input_extractor.extract_input(params)
      end

      def has_file_input!
        parent.has_file_input!
      end

      protected

      def create_component(component_class, theme_key, **attributes, &)
        attributes = apply_component_theme(attributes, theme_key)
        # TODO: refactor all this type checking code such that, the concerns will perform these actions.
        # Basically, invert control so that the component asks for the extra attributes
        # or calls #has_file_input!
        attributes = if component_class.include?(Phlexi::Form::Components::Concerns::HandlesInput)
          mix(input_attributes, attributes)
        else
          # we want to mix to ensure that any overrides are properly applied
          mix(attributes)
        end
        component = component_class.new(self, **attributes, &)
        if component_class.include?(Components::Concerns::ExtractsInput)
          raise "input component already defined: #{@field_input_extractor.inspect}" if @field_input_extractor

          @field_input_extractor = component
          has_file_input! if component_class.include?(Components::Concerns::UploadsFile)
        end

        component
      end

      def apply_component_theme(attributes, theme_key)
        return attributes if attributes.key?(:class!)

        theme_key = attributes.delete(:theme) || theme_key
        mix({class: themed(theme_key, self)}, attributes)
      end

      def determine_initial_value(value)
        return value unless value == NIL_VALUE

        determine_value_from_association || super
      end

      def determine_value_from_association
        return unless association_reflection.present?

        value = object.public_send(key)
        case association_reflection.macro
        when :has_many, :has_and_belongs_to_many
          value&.map { |v| v.public_send(association_reflection.klass.primary_key) }
        when :belongs_to, :has_one
          value&.public_send(association_reflection.klass.primary_key)
        else
          raise ArgumentError, "Unsupported association type: #{association_reflection.macro}"
        end
      end
    end
  end
end
