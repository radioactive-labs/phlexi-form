# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class CollectionCheckboxes < Base
        include Concerns::HandlesInput
        include Concerns::HandlesArrayInput
        include Concerns::AcceptsChoices

        def view_template
          div(**attributes.slice(:id, :class)) do
            field.repeated(choices.values) do |builder|
              render builder.hidden_field_tag if builder.index == 0

              field = builder.field(
                label: choices[builder.key],
                # We set the attributes here so they are applied to all input components even if the user decides to use a block
                input_attributes: {
                  checked_value: builder.key,
                  include_hidden: false,
                  checked: selected?(builder.key)
                }
              )
              if block_given?
                yield field
              else
                render field.checkbox_tag
                render field.label_tag
              end
            end
          end
        end

        protected

        def build_attributes
          super
          attributes[:multiple] = true
        end
      end
    end
  end
end
