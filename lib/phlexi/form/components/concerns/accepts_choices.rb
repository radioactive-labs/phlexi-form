# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module AcceptsChoices
          protected

          def build_attributes
            super
            @label_method = attributes.delete(:label_method)
            @value_method = attributes.delete(:value_method)
            @group_method = attributes.delete(:group_method)
            @group_label_method = attributes.delete(:group_label_method)
          end

          def choices
            @choices ||= begin
              collection = attributes.delete(:choices) || field.choices
              build_choice_mapper(collection)
            end
          end

          def selected?(option)
            if attributes[:multiple]
              Array(field.value).any? { |item| item.to_s == option.to_s }
            else
              field.value.to_s == option.to_s
            end
          end

          def normalize_simple_input(input_value)
            # ensure that choice is in the list
            ([super] & choices.values)[0]
          end

          def build_choice_mapper(collection)
            if @group_method
              GroupedChoicesMapper.new(
                collection,
                group_method: @group_method,
                group_label_method: @group_label_method,
                label_method: @label_method,
                value_method: @value_method
              )
            else
              SimpleChoicesMapper.new(
                collection,
                label_method: @label_method,
                value_method: @value_method
              )
            end
          end
        end
      end
    end
  end
end
