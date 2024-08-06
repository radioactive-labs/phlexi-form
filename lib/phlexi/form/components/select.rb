# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Select < Base
        include Concerns::HandlesInput
        include Concerns::HandlesArrayInput
        include Concerns::HasOptions

        def view_template(&block)
          select(**attributes) do
            blank_option { blank_option_text } unless skip_blank_option?
            options
          end
        end

        protected

        def options
          option_mapper.each do |value, label|
            option(selected: selected?(value), value: value) { label }
          end
        end

        def blank_option(&)
          option(selected: field.value.nil?, &)
        end

        def build_attributes
          super

          attributes[:id] = field.dom.id
          attributes[:name] = field.dom.name

          build_select_attributes
        end

        def build_select_attributes
          @include_blank = attributes.delete(:include_blank)

          attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
          attributes[:required] = attributes.fetch(:required, field.required?)
          attributes[:disabled] = attributes.fetch(:disabled, field.disabled?)
          attributes[:multiple] = attributes.fetch(:multiple, field.multiple?)
          attributes[:size] = attributes.fetch(:size, field.limit)
        end

        def blank_option_text
          field.placeholder
        end

        def skip_blank_option?
          @include_blank == false
        end

        def normalize_input(input_value)
          attributes[:multiple] ? normalize_array_input(input_value) : normalize_simple_input(input_value)
        end
      end
    end
  end
end
