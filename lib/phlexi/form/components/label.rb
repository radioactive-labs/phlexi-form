# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Label < Base
        def view_template
          label(**attributes) do
            if field.required?
              abbr(title: "required") { "*" }
              whitespace
            end
            plain field.label
          end
        end

        protected

        def build_attributes
          super
          attributes[:for] ||= field.dom.id
        end
      end
    end
  end
end
