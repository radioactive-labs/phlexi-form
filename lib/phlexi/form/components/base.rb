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
        end

        protected

        def build_attributes
          attributes[:id] ||= "#{field.dom.id}_#{component_name}"
          attributes[:class] = tokens(
            component_name,
            attributes[:class],
            -> { field.required? } => "required",
            -> { !field.required? } => "optional",
            -> { field.has_errors? } => "invalid",
            -> { field.readonly? } => "readonly",
            -> { field.disabled? } => "disabled"
          )
        end

        def component_name
          @component_name ||= self.class.name.demodulize.underscore
        end
      end
    end
  end
end
