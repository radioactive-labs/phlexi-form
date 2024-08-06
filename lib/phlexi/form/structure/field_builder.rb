# frozen_string_literal: true

require "phlex"

module Phlexi
  module Form
    module Structure
      # FieldBuilder class is responsible for building form fields with various options and components.
      #
      # @attr_reader [Structure::DOM] dom The DOM structure for the field.
      # @attr_reader [Hash] options Options for the field.
      # @attr_reader [Object] object The object associated with the field.
      # @attr_reader [Hash] attributes Attributes for the field.
      # @attr_accessor [Object] value The value of the field.
      class FieldBuilder < Node
        include Phlex::Helpers
        include FieldOptions::Associations
        include FieldOptions::Themes
        include FieldOptions::Validators
        include FieldOptions::Labels
        include FieldOptions::Hints
        include FieldOptions::Errors
        include FieldOptions::InferredTypes
        include FieldOptions::Collection
        include FieldOptions::Placeholder
        include FieldOptions::Required
        include FieldOptions::Autofocus
        include FieldOptions::Disabled
        include FieldOptions::Readonly
        include FieldOptions::Length
        include FieldOptions::MinMax
        include FieldOptions::Pattern
        include FieldOptions::Multiple
        include FieldOptions::Limit

        attr_reader :dom, :options, :object, :input_attributes, :value

        # Initializes a new FieldBuilder instance.
        #
        # @param key [Symbol, String] The key for the field.
        # @param parent [Structure::Namespace] The parent object.
        # @param object [Object, nil] The associated object.
        # @param value [Object] The initial value for the field.
        # @param input_attributes [Hash] Default attributes to apply to input fields.
        # @param options [Hash] Additional options for the field.
        def initialize(key, parent:, object: nil, value: NIL_VALUE, input_attributes: {}, **options)
          super(key, parent: parent)

          @object = object
          @value = determine_initial_value(value)
          @input_attributes = input_attributes
          @options = options
          @dom = Structure::DOM.new(field: self)
        end

        # Creates a label tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the label.
        # @return [Components::Label] The label component.
        def label_tag(**attributes)
          create_component(Components::Label, :label, **attributes)
        end

        # Creates an input tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the input.
        # @return [Components::Input] The input component.
        def input_tag(**attributes)
          create_component(Components::Input, :input, **attributes)
        end

        # Creates a checkbox tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the checkbox.
        # @return [Components::Checkbox] The checkbox component.
        def checkbox_tag(**attributes)
          create_component(Components::Checkbox, :checkbox, **attributes)
        end

        # Creates collection checkboxes for the field.
        #
        # @param attributes [Hash] Additional attributes for the collection checkboxes.
        # @yield [block] The block to be executed for each checkbox.
        # @return [Components::CollectionCheckboxes] The collection checkboxes component.
        def collection_checkboxes_tag(**attributes, &)
          create_component(Components::CollectionCheckboxes, :collection_checkboxes, **attributes, &)
        end

        # Creates a radio button tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the radio button.
        # @return [Components::RadioButton] The radio button component.
        def radio_button_tag(**attributes)
          create_component(Components::RadioButton, :radio, **attributes)
        end

        # Creates collection radio buttons for the field.
        #
        # @param attributes [Hash] Additional attributes for the collection radio buttons.
        # @yield [block] The block to be executed for each radio button.
        # @return [Components::CollectionRadioButtons] The collection radio buttons component.
        def collection_radio_buttons_tag(**attributes, &)
          create_component(Components::CollectionRadioButtons, :collection_radio_buttons, **attributes, &)
        end

        # Creates a textarea tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the textarea.
        # @return [Components::Textarea] The textarea component.
        def textarea_tag(**attributes)
          create_component(Components::Textarea, :textarea, **attributes)
        end

        # Creates a select tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the select.
        # @return [Components::Select] The select component.
        def select_tag(**attributes)
          create_component(Components::Select, :select, **attributes)
        end

        def input_array_tag(**attributes)
          create_component(Components::InputArray, :array, **attributes)
        end

        # Creates a hint tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the hint.
        # @return [Components::Hint] The hint component.
        def hint_tag(**attributes)
          create_component(Components::Hint, :hint, **attributes)
        end

        # Creates an error tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the error.
        # @return [Components::Error] The error component.
        def error_tag(**attributes)
          create_component(Components::Error, :error, **attributes)
        end

        # Creates a full error tag for the field.
        #
        # @param attributes [Hash] Additional attributes for the full error.
        # @return [Components::FullError] The full error component.
        def full_error_tag(**attributes)
          create_component(Components::FullError, :full_error, **attributes)
        end

        # Wraps the field with additional markup.
        #
        # @param inner [Hash] Attributes for the inner wrapper.
        # @param attributes [Hash] Additional attributes for the wrapper.
        # @yield [block] The block to be executed within the wrapper.
        # @return [Components::Wrapper] The wrapper component.
        def wrapped(inner: {}, **attributes, &)
          wrapper_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :wrapper)
          inner[:class] = inner.delete(:class) || themed(inner.delete(:theme) || :inner_wrapper)
          Components::Wrapper.new(self, class: wrapper_class, inner: inner, **attributes, &)
        end

        # Creates a multi-value field collection.
        #
        # @param range [Integer, #to_a] The range of keys for each field. If an integer is passed, keys will begin from 1.
        # @yield [block] The block to be executed for each item in the collection.
        # @return [FieldCollection] The field collection.
        def multi(range = nil, &)
          FieldCollection.new(field: self, range: range, &)
        end

        # Creates a submit button
        #
        # @param attributes [Hash] Additional attributes for the submit.
        # @return [Components::SubmitButton] The submit button component.
        def submit_button_tag(**attributes, &)
          create_component(Components::SubmitButton, :submit_button, **attributes, &)
        end

        def extract_input(params)
          raise "field##{dom.name} did not define an input component" unless @field_input_component

          @field_input_component.extract_input(params)
        end

        protected

        def create_component(component_class, theme_key, **attributes)
          if component_class.include?(Phlexi::Form::Components::Concerns::HandlesInput)
            raise "input component already defined: #{@field_input_component.inspect}" if @field_input_component

            attributes = input_attributes.deep_merge(attributes)
            @field_input_component = component_class.new(self, class: component_class_for(theme_key, attributes), **attributes)
          else
            component_class.new(self, class: component_class_for(theme_key, attributes), **attributes)
          end
        end

        def component_class_for(theme_key, attributes)
          attributes.delete(:class) || themed(attributes.key?(:theme) ? attributes.delete(:theme) : theme_key)
        end

        def has_value?
          value.present?
        end

        def determine_initial_value(value)
          return value unless value == NIL_VALUE

          determine_from_association || determine_value_from_object
        end

        def determine_value_from_object
          object.respond_to?(key) ? object.public_send(key) : nil
        end

        def determine_from_association
          return nil unless reflection.present?

          value = object.public_send(key)
          case reflection.macro
          when :has_many
            value.map(&:to_param)
          else
            value.to_param
          end
        end
      end
    end
  end
end
