# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Min
        def min(min_value = nil)
          if min_value.nil?
            options.fetch(:min) { options[:min] = calculate_min }
          else
            options[:min] = min_value
            self
          end
        end

        private

        def calculate_min
          if (numericality_validator = find_numericality_validator)
            get_min_from_validator(numericality_validator)
          elsif (min = get_min_from_attribute(key))
            min
          end
        end

        def get_min_from_validator(validator)
          options = validator.options
          min = if options.key?(:greater_than)
            {value: options[:greater_than], exclusive: true}
          elsif options.key?(:greater_than_or_equal_to)
            {value: options[:greater_than_or_equal_to], exclusive: false}
          end
          evaluate_and_adjust_min(min)
        end

        def evaluate_and_adjust_min(min)
          return nil unless min

          value = evaluate_numericality_validator_option(min[:value])
          min[:exclusive] ? value + 1 : value
        end

        def get_min_from_attribute(attribute)
          if object.class.respond_to?(:attribute_types) && (attribute_type = object.class.attribute_types[attribute.to_s])
            if (range = attribute_type.instance_variable_get(:@range))
              range.min
            elsif attribute_type.respond_to?(:precision) && (precision = attribute_type.precision)
              -((precision**8) - ((step && step != "any") ? step : 0.000001))
            end
          end
        end
      end
    end
  end
end
