# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Required
        def required?
          options[:required] = options.fetch(:required) { calculate_required }
        end

        def required!(required = true)
          options[:required] = required
          self
        end

        private

        def calculate_required
          if has_validators?
            required_by_validators?
          else
            required_by_default?
          end
        end

        def required_by_validators?
          (attribute_validators + association_reflection_validators).any? { |v| v.kind == :presence && valid_validator?(v) }
        end

        def required_by_default?
          # TODO: get this from configuration
          false
        end
      end
    end
  end
end
