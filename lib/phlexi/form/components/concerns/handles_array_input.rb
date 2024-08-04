# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module HandlesArrayInput
          protected

          def normalize_input(input_value)
            normalize_array_input(input_value)
          end

          def normalize_array_input(input_value)
            Array(input_value).map { |nested_input_value| normalize_simple_input(nested_input_value) }.compact
          end
        end
      end
    end
  end
end
