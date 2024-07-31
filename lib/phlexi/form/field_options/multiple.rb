# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Multiple
        def multiple?
          options[:multiple] = options.fetch(:multiple) { calculate_multiple_field_value }
        end

        def multiple!(multiple = true)
          options[:multiple] = multiple
          self
        end

        private

        def calculate_multiple_field_value
          return true if multiple_field_array_attribute?
          check_multiple_field_from_validators
        end

        def multiple_field_array_attribute?
          return false unless object.class.respond_to?(:columns_hash)

          column = object.class.columns_hash[key.to_s]
          return false unless column

          case object.class.connection.adapter_name.downcase
          when "postgresql"
            column.array? || (column.type == :string && column.sql_type.include?("[]"))
          end # || object.class.attribute_types[key.to_s].is_a?(ActiveRecord::Type::Serialized)
        rescue => e
          Rails.logger.warn("Error checking multiple field array attribute: #{e.message}")
          false
        end

        def check_multiple_field_from_validators
          inclusion_validator = find_validator(:inclusion)
          length_validator = find_validator(:length)

          return false unless inclusion_validator || length_validator

          check_multiple_field_inclusion_validator(inclusion_validator) ||
            check_multiple_field_length_validator(length_validator)
        end

        def check_multiple_field_inclusion_validator(validator)
          return false unless validator
          in_option = validator.options[:in]
          return false unless in_option.is_a?(Array)

          validator.options[:multiple] == true || (multiple_field_array_attribute? && in_option.size > 1)
        end

        def check_multiple_field_length_validator(validator)
          return false unless validator
          validator.options[:maximum].to_i > 1 if validator.options[:maximum]
        end
      end
    end
  end
end
