# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class CollectionCheckboxes < Base
        include Concerns::HasOptions

        def view_template
          render field.input_tag(type: :hidden, value: "", theme: false, hidden: true, autocomplete: "off", multiple: true)
          field.multi(option_mapper.values) do |builder|
            field = builder.field(
              label: option_mapper[builder.key],
              # We set the attributes here so they are applied to all components even if the user decides to use a block
              attributes: {
                checked_value: builder.key,
                include_hidden: false
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
    end
  end
end
