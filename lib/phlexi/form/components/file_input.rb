# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class FileInput < Input
        include Phlexi::Form::Components::Concerns::UploadsFile

        def view_template
          input(type: :hidden, name: attributes[:name], value: "", autocomplete: "off", hidden: true) if include_hidden?
          input(**attributes)
        end

        protected

        def build_input_attributes
          attributes[:type] = :file
          super

          @include_hidden = attributes.delete(:include_hidden)
          # ensure we are always setting it to false
          attributes[:value] = false
        end

        def include_hidden?
          return false if @include_hidden == false

          attributes[:multiple]
        end

        def normalize_input(input_value)
          input_value
        end
      end
    end
  end
end
