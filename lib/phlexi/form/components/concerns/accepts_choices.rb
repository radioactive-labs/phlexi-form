# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module AcceptsChoices
          protected

          def build_attributes
            super
            @choice_collection = attributes.delete(:choices) || field.choices
            @label_method = attributes.delete(:label_method)
            @value_method = attributes.delete(:value_method)
          end

          def choices
            @choices ||= ChoicesMapper.new(@choice_collection, label_method: @label_method, value_method: @value_method)
          end

          def selected?(option)
            if attributes[:multiple]
              field_value.any? { |item| item.to_s == option.to_s }
            else
              field_value.to_s == option.to_s
            end
          end

          def field_value
            if attributes[:multiple]
              Array(field.value)
            else
              field.value
            end
          end

          def normalize_simple_input(input_value)
            ([super] & choices.values)[0]
          end
        end
      end
    end
  end
end
