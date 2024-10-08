# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class CollectionRadioButtons < Base
        include Concerns::HandlesInput
        include Concerns::HasOptions

        def view_template
          div(**attributes.slice(:id, :class)) do
            field.repeated(option_mapper.values) do |builder|
              render builder.hidden_field_tag if builder.index == 0

              field = builder.field(
                label: option_mapper[builder.key],
                # We set the attributes here so they are applied to all input components even if the user decides to use a block
                input_attributes: {
                  checked_value: builder.key,
                  checked: selected?(builder.key)
                }
              )
              if block_given?
                yield field
              else
                render field.radio_button_tag
                render field.label_tag
              end
            end
          end
        end
      end
    end
  end
end
