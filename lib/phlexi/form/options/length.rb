# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Length
        def minlength(minlength = nil)
          if minlength.nil?
            options.fetch(:minlength) { options[:minlength] = calculate_minlength }
          else
            options[:minlength] = minlength
            self
          end
        end

        def maxlength(maxlength = nil)
          if maxlength.nil?
            options.fetch(:maxlength) { options[:maxlength] = calculate_maxlength }
          else
            options[:maxlength] = maxlength
            self
          end
        end

        private

        def calculate_minlength
          minimum_length_value_from(find_length_validator)
        end

        def minimum_length_value_from(length_validator)
          if length_validator
            length_validator.options[:is] || length_validator.options[:minimum]
          end
        end

        def calculate_maxlength
          maximum_length_value_from(find_length_validator)
        end

        def maximum_length_value_from(length_validator)
          if length_validator
            length_validator.options[:is] || length_validator.options[:maximum]
          end
        end

        def find_length_validator
          find_validator(:length)
        end
      end
    end
  end
end
