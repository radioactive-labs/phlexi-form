# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Base < Phlexi::Form::HTML
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

          classes = [component_name]
          classes << "required" if attributes[:required]
          classes << "optional" unless attributes[:required]
          classes << "invalid" if field.has_errors?
          classes << "readonly" if attributes[:readonly]
          classes << "disabled" if attributes[:disabled]
          classes << attributes[:class] if attributes[:class]
          attributes[:class] = classes.join(" ")
        end

        def component_name
          @component_name ||= self.class.name.demodulize.underscore
        end
      end
    end
  end
end
