# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Base < COMPONENT_BASE
        attr_reader :field, :attributes

        def initialize(field, **attributes)
          @field = field
          @attributes = attributes

          build_attributes
          append_attribute_classes
        end

        protected

        def build_attributes
          attributes.fetch(:id) { attributes[:id] = "#{field.dom.id}_#{component_name}" }
        end

        def append_attribute_classes
          return if attributes[:class] == false

          default_classes = tokens(
            component_name,
            -> { attributes[:required] } => "required",
            -> { !attributes[:required] } => "optional",
            -> { field.has_errors? } => "invalid",
            -> { attributes[:readonly] } => "readonly",
            -> { attributes[:disabled] } => "disabled"
          )
          attributes[:class] = tokens(default_classes, attributes[:class])
        end

        def component_name
          @component_name ||= self.class.name.demodulize.underscore
        end
      end
    end
  end
end
