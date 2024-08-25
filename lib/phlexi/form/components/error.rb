# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Error < Base
        def view_template
          p(**attributes) do
            field.error
          end
        end

        private

        def render?
          field.show_errors?
        end
      end
    end
  end
end
