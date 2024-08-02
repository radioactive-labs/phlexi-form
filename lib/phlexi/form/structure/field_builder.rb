# frozen_string_literal: true

require "phlex"

module Phlexi
  module Form
    module Structure
      class FieldBuilder < Node
        include Phlex::Helpers
        include FieldOptions::Validators
        include FieldOptions::Labels
        include FieldOptions::Hints
        include FieldOptions::Errors
        include FieldOptions::Type
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

        attr_reader :dom, :options, :object, :attributes
        attr_accessor :value
        alias_method :serialize, :value
        alias_method :assign, :value=


        # @param attributes [Hash] Default attributes to apply to all fields. Takes priority over inferred attributes.
        def initialize(key, parent:, object: nil, value: :__i_form_builder_nil_value_i__, attributes: {}, **options)
          key = :"#{key}"
          super(key, parent: parent)

          @object = object
          @value = if value != :__i_form_builder_nil_value_i__
            value
          else
            object.respond_to?(key) ? object.send(key) : nil
          end
          @attributes = attributes
          @options = options
          @dom = Structure::DOM.new(field: self)
        end

        def label_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          label_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :label)
          Components::Label.new(self, class: label_class, **attributes)
        end

        def input_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          input_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :input)
          Components::Input.new(self, class: input_class, **attributes)
        end

        def checkbox_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          checkbox_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :checkbox)
          Components::Checkbox.new(self, class: checkbox_class, **attributes)
        end

        def collection_checkboxes_tag(**attributes, &)
          attributes = self.attributes.deep_merge(attributes)
          collection_checkboxes_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :collection_checkboxes)
          Components::CollectionCheckboxes.new(self, class: collection_checkboxes_class, **attributes, &)
        end

        def radio_button_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          radio_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :radio)
          Components::RadioButton.new(self, class: radio_class, **attributes)
        end

        def collection_radio_buttons_tag(**attributes, &)
          attributes = self.attributes.deep_merge(attributes)
          collection_radio_buttons_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :collection_radio_buttons)
          Components::CollectionRadioButtons.new(self, class: collection_radio_buttons_class, **attributes, &)
        end

        def textarea_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          textarea_class = attributes.delete(:class) || themed_input(attributes.delete(:theme) || :textarea)
          Components::Textarea.new(self, class: textarea_class, **attributes)
        end

        def select_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          select_class = attributes.delete(:class) || themed_input(attributes.delete(:theme) || :select)
          Components::Select.new(self, class: select_class, **attributes)
        end

        def hint_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          hint_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :hint)
          Components::Hint.new(self, class: hint_class, **attributes)
        end

        def error_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          error_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :error)
          Components::Error.new(self, class: error_class, **attributes)
        end

        def full_error_tag(**attributes)
          attributes = self.attributes.deep_merge(attributes)
          error_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :error)
          Components::FullError.new(self, class: error_class, **attributes)
        end

        def wrapped(inner: {}, **attributes, &)
          attributes = self.attributes.deep_merge(attributes)
          wrapper_class = attributes.delete(:class) || themed(attributes.delete(:theme) || :wrapper)
          inner[:class] = inner.delete(:class) || themed(inner.delete(:theme) || :inner_wrapper)
          Components::Wrapper.new(self, class: wrapper_class, inner:, **attributes, &)
        end

        # Wraps a field that's an array of values with a bunch of fields
        #
        # @example Usage
        #
        # ```ruby
        # Phlexi::Form.new User.new do
        #   render field(:email).input_tag
        #   render field(:name).input_tag
        #   field(:roles).multi([["Admin", "admin"], ["Editor", "editor"]]) do |a|
        #     render a.label_tag # Admin
        #     render a.input_tag # => name="user[roles][]" value="admin"
        #   end
        # end
        # ```
        # The object within the block is a `FieldCollection` object
        def multi(range = nil, &)
          range ||= Array(collection)
          FieldCollection.new(field: self, range:, &)
        end

        private

        def themed(component)
          tokens(resolve_theme(component), resolve_validity_theme(component)).presence if component
        end

        def themed_input(input_component)
          themed(input_component) || themed(:input) if input_component
        end

        def resolve_theme(property)
          options[property] || theme[property]
        end

        def resolve_validity_theme(property)
          validity_property = if has_errors?
            # Apply invalid class if the object has errors
            :"invalid_#{property}"
          elsif (object.respond_to?(:persisted?) && object.persisted?) && (object.respond_to?(:errors) && !object.errors.empty?)
            # The object is persisted, has been validated, and there are errors (not empty), but this field has no errors
            # Apply valid class
            :"valid_#{property}"
          else
            :"neutral_#{property}"
          end

          resolve_theme(validity_property)
        end

        def theme
          @theme ||= {
            # # label themes
            # label: "md:w-1/6 mt-2 block mb-2 text-sm font-medium",
            # invalid_label: "text-red-700 dark:text-red-500",
            # valid_label: "text-green-700 dark:text-green-500",
            # neutral_label: "text-gray-700 dark:text-white",
            # # input themes
            # input: "w-full p-2 border rounded-md shadow-sm font-medium text-sm dark:bg-gray-700",
            # invalid_input: "bg-red-50 border-red-500 dark:border-red-500 text-red-900 dark:text-red-500 placeholder-red-700 dark:placeholder-red-500 focus:ring-red-500 focus:border-red-500",
            # valid_input: "bg-green-50 border-green-500 dark:border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500",
            # neutral_input: "border-gray-300 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white focus:ring-primary-500 focus:border-primary-500",
            # # hint themes
            # hint: "mt-2 text-sm text-gray-500 dark:text-gray-200",
            # # error themes
            # error: "mt-2 text-sm text-red-600 dark:text-red-500",
            # # wrapper themes
            # wrapper: "flex flex-col md:flex-row items-start space-y-2 md:space-y-0 md:space-x-2 mb-4",
            # inner_wrapper: "md:w-5/6 w-full",
          }.freeze
        end

        def reflection = nil

        def has_value?
          value.present?
        end
      end
    end
  end
end
