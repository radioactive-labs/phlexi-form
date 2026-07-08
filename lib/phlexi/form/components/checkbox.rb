# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Checkbox < Input
        def view_template
          input(type: :hidden, name: attributes[:name], value: @unchecked_value, autocomplete: "off", hidden: true) if include_hidden?
          input(**attributes, value: @checked_value)
        end

        protected

        def build_input_attributes
          attributes[:type] = :checkbox
          super

          @include_hidden = attributes.delete(:include_hidden)
          @checked_value = (attributes.key?(:checked_value) ? attributes.delete(:checked_value) : "1").to_s
          @unchecked_value = (attributes.key?(:unchecked_value) ? attributes.delete(:unchecked_value) : "0").to_s

          attributes[:value] = @checked_value
          attributes[:checked] = attributes.fetch(:checked) { checked? }
        end

        def include_hidden?
          @include_hidden != false
        end

        # Stringified form of Rails' ActiveModel::Type::Boolean::FALSE_VALUES.
        # Kept as a literal set (rather than depending on activemodel) so a
        # boolean-ish value from a JSON/text column or params — "f", "F",
        # "FALSE", "off", 0, :false, ... — is recognised as unchecked. The
        # component compares field.dom.value, which stringifies the underlying
        # value, so the integer/symbol/boolean forms collapse onto these.
        FALSE_VALUES = ["", "0", "f", "F", "false", "FALSE", "off", "OFF"].freeze

        def checked?
          return false if field.dom.value == @unchecked_value

          if @checked_value == "1" # using default values
            # handle nils, numbers and booleans
            !FALSE_VALUES.include?(field.dom.value)
          else # custom value, so explicit match
            field.dom.value == @checked_value
          end
        end

        def normalize_input(...)
          input_value = super
          return if input_value.nil?
          [@checked_value, @unchecked_value].include?(input_value) ? input_value : @unchecked_value
        end
      end
    end
  end
end
