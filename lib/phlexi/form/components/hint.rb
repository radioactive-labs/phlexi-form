# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class Hint < Base
        def view_template
          p(**attributes) do
            field.hint
          end
        end

        private

        def render?
          field.hint.present? && (!field.show_errors? || !field.has_errors?)
        end
      end
    end
  end
end
