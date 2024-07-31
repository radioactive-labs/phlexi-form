# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class FullError < Base
        def view_template
          p(**attributes) do
            field.full_error
          end
        end

        private

        def render?
          field.show_errors? && field.has_errors?
        end
      end
    end
  end
end
