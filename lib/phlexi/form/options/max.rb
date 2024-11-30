# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Max
        def max(max_value = nil)
          if max_value.nil?
            options.fetch(:max) { options[:max] = calculate_max }
          else
            options[:max] = max_value
            self
          end
        end

        private

        def calculate_max
          if (numericality_validator = find_numericality_validator)
            get_max_from_validator(numericality_validator)
          else
            get_max_from_attribute(key)
          end
        end

        def get_max_from_validator(validator)
          options = validator.options
          max = if options.key?(:less_than)
            {value: options[:less_than], exclusive: true}
          elsif options.key?(:less_than_or_equal_to)
            {value: options[:less_than_or_equal_to], exclusive: false}
          end
          evaluate_and_adjust_max(max)
        end

        def evaluate_and_adjust_max(max)
          return nil unless max

          value = evaluate_numericality_validator_option(max[:value])
          max[:exclusive] ? value - 1 : value
        end

        def get_max_from_attribute(attribute)
          if object.class.respond_to?(:attribute_types) && (attribute_type = object.class.attribute_types[attribute.to_s])
            if (range = attribute_type.instance_variable_get(:@range))
              range.max
              # elsif attribute_type.respond_to?(:precision) && (precision = attribute_type.precision)
              #   (precision**8) - ((step && step != "any") ? step : 0.000001)
            end
          end
        end
      end
    end
  end
end
