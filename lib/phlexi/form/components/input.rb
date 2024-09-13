# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Input < Base
        include Concerns::HandlesInput

        def view_template
          input(**attributes)
        end

        protected

        def build_attributes
          super

          attributes[:value] = field.dom.value

          build_input_attributes
        end

        def build_input_attributes
          attributes.fetch(:type) { attributes[:type] = field.inferred_string_field_type }
          attributes.fetch(:disabled) { attributes[:disabled] = field.disabled? }

          case attributes[:type]
          when :text, :password, :email, :tel, :url, :search
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
            attributes.fetch(:placeholder) { attributes[:placeholder] = field.placeholder }
            attributes.fetch(:minlength) { attributes[:minlength] = field.minlength }
            attributes.fetch(:maxlength) { attributes[:maxlength] = field.maxlength }
            attributes.fetch(:readonly) { attributes[:readonly] = field.readonly? }
            attributes.fetch(:required) { attributes[:required] = field.required? }
            attributes.fetch(:pattern) { attributes[:pattern] = field.pattern }
          when :number
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
            attributes.fetch(:placeholder) { attributes[:placeholder] = field.placeholder }
            attributes.fetch(:readonly) { attributes[:readonly] = field.readonly? }
            attributes.fetch(:required) { attributes[:required] = field.required? }
            attributes.fetch(:min) { attributes[:min] = field.min }
            attributes.fetch(:max) { attributes[:max] = field.max }
            attributes.fetch(:step) { attributes[:step] = field.step }
          when :checkbox, :radio
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
            attributes.fetch(:required) { attributes[:required] = field.required? }
          when :file
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
            attributes.fetch(:required) { attributes[:required] = field.required? }
            attributes.fetch(:multiple) { attributes[:multiple] = field.multiple? }
          when :date, :time, :datetime_local
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
            attributes.fetch(:readonly) { attributes[:readonly] = field.readonly? }
            attributes.fetch(:required) { attributes[:required] = field.required? }
            attributes.fetch(:min) { attributes[:min] = field.min }
            attributes.fetch(:max) { attributes[:max] = field.max }
          when :color
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
          when :range
            attributes.fetch(:autofocus) { attributes[:autofocus] = field.focused? }
            attributes.fetch(:min) { attributes[:min] = field.min }
            attributes.fetch(:max) { attributes[:max] = field.max }
            attributes.fetch(:step) { attributes[:step] = field.step }
          when :hidden
            attributes[:class] = false
            attributes[:hidden] = true
            attributes[:autocomplete] = "off"
          else
            # Handle any unrecognized input types
            # Rails.logger.warn("Unhandled input type: #{attributes[:type]}")
          end

          if (attributes[:type] == :file) ? attributes[:multiple] : attributes.delete(:multiple)
            attributes[:name] = "#{attributes[:name].sub(/\[\]$/, "")}[]"
          end
        end
      end
    end
  end
end
