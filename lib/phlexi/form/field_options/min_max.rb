# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module MinMax
        def min(min_value = nil)
          if min_value.nil?
            options[:min] = options.fetch(:min) { calculate_min }
          else
            options[:min] = min_value
            self
          end
        end

        def max(max_value = nil)
          if max_value.nil?
            options[:max] = options.fetch(:max) { calculate_max }
          else
            options[:max] = max_value
            self
          end
        end

        def step
          1 if min || max
        end

        private

        def calculate_min
          if (numericality_validator = find_numericality_validator)
            get_min_from_validator(numericality_validator)
          end
        end

        def calculate_max
          if (numericality_validator = find_numericality_validator)
            get_max_from_validator(numericality_validator)
          end
        end

        def find_numericality_validator
          find_validator(:numericality)
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

        def get_max_from_validator(validator)
          options = validator.options
          max = if options.key?(:less_than)
            {value: options[:less_than], exclusive: true}
          elsif options.key?(:less_than_or_equal_to)
            {value: options[:less_than_or_equal_to], exclusive: false}
          end
          evaluate_and_adjust_max(max)
        end

        def evaluate_and_adjust_min(min)
          return nil unless min

          value = evaluate_numericality_validator_option(min[:value])
          min[:exclusive] ? value + 1 : value
        end

        def evaluate_and_adjust_max(max)
          return nil unless max

          value = evaluate_numericality_validator_option(max[:value])
          max[:exclusive] ? value - 1 : value
        end

        def evaluate_numericality_validator_option(option)
          case option
          when Proc
            option.arity.zero? ? option.call : option.call(object)
          else
            option
          end
        end
      end
    end
  end
end
