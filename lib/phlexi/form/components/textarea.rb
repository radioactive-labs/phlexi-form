# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Textarea < Base
        def view_template
          textarea(**attributes) { field.dom.value }
        end

        protected

        def build_attributes
          super

          attributes[:id] = field.dom.id
          attributes[:name] = field.dom.name

          build_textarea_attributes
        end

        def build_textarea_attributes
          attributes[:placeholder] = attributes.fetch(:placeholder, field.placeholder)
          attributes[:autofocus] = attributes.fetch(:autofocus, field.focused?)
          attributes[:minlength] = attributes.fetch(:minlength, field.minlength)
          attributes[:maxlength] = attributes.fetch(:maxlength, field.maxlength)
          attributes[:readonly] = attributes.fetch(:readonly, field.readonly?)
          attributes[:required] = attributes.fetch(:required, field.required?)
          attributes[:disabled] = attributes.fetch(:disabled, field.disabled?)
        end
      end
    end
  end
end
