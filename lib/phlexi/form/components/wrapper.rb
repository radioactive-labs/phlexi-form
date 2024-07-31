# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Wrapper < Base
        attr_reader :inner_attributes

        def view_template
          div(**attributes) do
            render field.label_tag
            div(**inner_attributes) do
              yield field if block_given?
              render field.full_error_tag
              render field.hint_tag
            end
          end
        end

        protected

        def build_attributes
          super

          @inner_attributes = attributes.delete(:inner) || {}
          inner_attributes[:class] = tokens("inner-wrapper", inner_attributes[:class])
        end
      end
    end
  end
end
