# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Pattern
        def pattern(pattern = nil)
          if pattern.nil?
            options[:pattern] = options.fetch(:pattern) { calculate_pattern }
          else
            options[:pattern] = pattern
            self
          end
        end

        private

        def calculate_pattern
          if (pattern_validator = find_pattern_validator) && (with = pattern_validator.options[:with])
            evaluate_format_validator_option(with).source
          end
        end

        def find_pattern_validator
          find_validator(:format)
        end

        def evaluate_format_validator_option(option)
          if option.respond_to?(:call)
            option.call(object)
          else
            option
          end
        end
      end
    end
  end
end
