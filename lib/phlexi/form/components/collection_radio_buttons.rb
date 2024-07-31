# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class CollectionRadioButtons < Base
        include Concerns::HasOptions

        def view_template
          render field.input_tag(type: :hidden, value: "", theme: false, hidden: true, autocomplete: "off")
          field.multi(option_mapper.values) do |builder|
            field = builder.field(
              label: option_mapper[builder.key],
              attributes: {
                checked_value: builder.key
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
