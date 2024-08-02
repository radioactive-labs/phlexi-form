# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module HandlesArrayInput
          protected

          def normalize_input(input_hash)
            normalize_array_input(input_hash)
          end

          def normalize_array_input(input_hash)
            input_hash.transform_values { |value|
              Array(value).map { |nested_value| normalize_input_value(nested_value) }.compact
            }
          end
        end
      end
    end
  end
end
