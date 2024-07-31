# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Input < Base
        def view_template
          input(**attributes)
        end

        protected

        def build_attributes
          super

          # only overwrite id if it was set in Base
          attributes[:id] = field.dom.id if attributes[:id] == "#{field.dom.id}_#{component_name}"
          attributes[:name] = field.dom.name
          attributes[:value] = field.dom.value

          build_input_attributes
        end

        def build_input_attributes
          attributes[:type] = attributes.fetch(:type, field.input_type)
          attributes[:disabled] = attributes.fetch(:disabled, field.disabled?)

          case attributes[:type]
          when :text, :password, :email, :tel, :url, :search
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
            attributes[:placeholder] = attributes.fetch(:placeholder, field.placeholder)
            attributes[:minlength] = attributes.fetch(:minlength, field.minlength)
            attributes[:maxlength] = attributes.fetch(:maxlength, field.maxlength)
            attributes[:readonly] = attributes.fetch(:readonly, field.readonly?)
            attributes[:required] = attributes.fetch(:required, field.required?)
            attributes[:pattern] = attributes.fetch(:pattern, field.pattern)
          when :number
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
            attributes[:placeholder] = attributes.fetch(:placeholder, field.placeholder)
            attributes[:readonly] = attributes.fetch(:readonly, field.readonly?)
            attributes[:required] = attributes.fetch(:required, field.required?)
            attributes[:min] = attributes.fetch(:min, field.min)
            attributes[:max] = attributes.fetch(:max, field.max)
            attributes[:step] = attributes.fetch(:step, field.step)
          when :checkbox, :radio
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
            attributes[:required] = attributes.fetch(:required, field.required?)
          when :file
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
            attributes[:required] = attributes.fetch(:required, field.required?)
            attributes[:multiple] = attributes.fetch(:multiple, field.multiple)
            attributes[:accept] = attributes.fetch(:accept, field.accept)
          when :date, :time, :datetime_local
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
            attributes[:readonly] = attributes.fetch(:readonly, field.readonly?)
            attributes[:required] = attributes.fetch(:required, field.required?)
            attributes[:min] = attributes.fetch(:min, field.min)
            attributes[:max] = attributes.fetch(:max, field.max)
          when :color
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
          when :range
            attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
            attributes[:min] = attributes.fetch(:min, field.min)
            attributes[:max] = attributes.fetch(:max, field.max)
            attributes[:step] = attributes.fetch(:step, field.step)
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
