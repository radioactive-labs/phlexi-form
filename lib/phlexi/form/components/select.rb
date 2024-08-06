# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Select < Base
        include Concerns::HandlesInput
        include Concerns::HandlesArrayInput
        include Concerns::HasOptions

        def view_template
          input(type: :hidden, name: attributes[:name], value: "", autocomplete: "off", hidden: true) if include_hidden?
          select(**attributes) do
            blank_option { blank_option_text } if include_blank?
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
          @include_hidden = attributes.delete(:include_hidden)

          attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
          attributes[:required] = attributes.fetch(:required, field.required?)
          attributes[:disabled] = attributes.fetch(:disabled, field.disabled?)
          attributes[:multiple] = attributes.fetch(:multiple, field.multiple?)
          attributes[:size] = attributes.fetch(:size, field.limit)
        end

        def blank_option_text
          field.placeholder
        end

        def include_blank?
          return true if @include_blank == true

          @include_blank != false && !attributes[:multiple]
        end

        def include_hidden?
          return false if @include_hidden == false

          attributes[:multiple]
        end

        def normalize_input(input_value)
          attributes[:multiple] ? normalize_array_input(input_value) : normalize_simple_input(input_value)
        end
      end
    end
  end
end
