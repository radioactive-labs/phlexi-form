# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Range < Input
        def view_template
          input(**attributes, value: @checked_value)
        end

        protected

        def build_input_attributes
          attributes[:type] = :range
          super
        end
      end
    end
  end
end
