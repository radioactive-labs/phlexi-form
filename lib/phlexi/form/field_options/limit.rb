# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Limit
        def limit(limit = nil)
          if limit.nil?
            options[:limit] = options.fetch(:limit) { calculate_limit }
          else
            options[:limit] = limit
            self
          end
        end

        private

        def calculate_limit
          return unless multiple?

          limit_from_validators = [
            limit_from_length_validator,
            limit_from_inclusion_validator
          ].compact.min

          limit_from_validators || limit_from_db_column
        end

        def limit_from_length_validator
          length_validator = find_validator(:length)
          return unless length_validator

          length_validator.options[:maximum]
        end

        def limit_from_inclusion_validator
          return unless has_validators?

          inclusion_validator = find_validator(:inclusion)
          return unless inclusion_validator

          in_option = inclusion_validator.options[:in]
          in_option.is_a?(Array) ? in_option.size : nil
        end

        def limit_from_db_column
          return unless object.class.respond_to?(:columns_hash)

          column = object.class.columns_hash[key.to_s]
          return unless column

          case object.class.connection.adapter_name.downcase
          when "postgresql"
            if column.array?
              # Check if there's a limit on the array size
              column.limit
            elsif column.type == :string && column.sql_type.include?("[]")
              # For string arrays, extract the limit if specified
              column.sql_type.match(/\[(\d+)\]/)&.captures&.first&.to_i
            end
          end
        end
      end
    end
  end
end
