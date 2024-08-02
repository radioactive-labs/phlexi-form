# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class InputArray < Base
        include Concerns::HandlesInput
        include Concerns::HandlesArrayInput

        def view_template
          div(**attributes.slice(:id, :class)) do
            field.multi(values.length) do |builder|
              render builder.hidden_field_tag if builder.index == 0

              field = builder.field(
                label: builder.key,
                # we expect key to be an integer string starting from "1"
                value: values[builder.index]
              )
              if block_given?
                yield field
              else
                render field.input_tag
              end
            end
          end
        end

        protected

        def build_attributes
          super

          attributes[:multiple] = true
        end

        private

        def values
          @values ||= Array(field.value)
        end
      end
    end
  end
end
