# frozen_string_literal: true

require "bigdecimal"

module Phlexi
  module Form
    module FieldOptions
      module InferredTypes
        def inferred_db_type
          @inferred_db_type ||= infer_db_type
        end

        # This will give you the component type e.g. input, textarea, select
        def inferred_component_type
          @inferred_component_type ||= infer_component_type
        end

        # This will give you the subtype of the input component e.g input type="text|date|checkbox" etc
        def inferred_input_component_subtype
          @inferred_input_component_subtype ||= infer_input_component_subtype(inferred_component_type)
        end

        private

        # this returns the element type
        # one of :input, :textarea, :select
        def infer_component_type
          return :select unless collection.nil?

          case inferred_db_type
          when :text, :json, :jsonb, :hstore
            :textarea
          else
            :input
          end
        end

        # this only applies when input_component is `:input`
        # resolves the type attribute of input components
        def infer_input_component_subtype(component)
          case inferred_db_type
          when :string
            infer_string_input_type(key)
          when :integer, :float, :decimal
            :number
          when :date
            :date
          when :datetime
            :datetime
          when :time
            :time
          when :boolean
            :checkbox
          else
            :text
          end
        end

        def infer_db_type
          if object.class.respond_to?(:columns_hash)
            # ActiveRecord object
            column = object.class.columns_hash[key.to_s]
            return column.type if column
          end

          if object.class.respond_to?(:attribute_types)
            # ActiveModel::Attributes
            custom_type = object.class.attribute_types[key.to_s]
            return custom_type.type if custom_type&.type
          end

          # Check if object responds to the key
          if object.respond_to?(key)
            # Fallback to inferring type from the value
            return infer_db_type_from_value(object.send(key))
          end

          # Default to string if we can't determine the type
          :string
        end

        def infer_db_type_from_value(value)
          case value
          when Integer
            :integer
          when Float
            :float
          when BigDecimal
            :decimal
          when TrueClass, FalseClass
            :boolean
          when Date
            :date
          when Time, DateTime
            :datetime
          else
            :string
          end
        end

        def infer_string_input_type(key)
          key = key.to_s.downcase

          return :password if is_password_field?

          custom_type = custom_string_input_type(key)
          return custom_type if custom_type

          if has_validators?
            infer_string_input_type_from_validations
          else
            :text
          end
        end

        def custom_string_input_type(key)
          custom_mappings = {
            /url$|^link|^site/ => :url,
            /^email/ => :email,
            /^search/ => :search,
            /phone|tel(ephone)?/ => :tel,
            /^time/ => :time,
            /^date/ => :date,
            /^number|_count$|_amount$/ => :number,
            /^color/ => :color
          }

          custom_mappings.each do |pattern, type|
            return type if key.match?(pattern)
          end

          nil
        end

        def infer_string_input_type_from_validations
          if attribute_validators.find { |v| v.kind == :numericality }
            :number
          elsif attribute_validators.find { |v| v.kind == :format && v.options[:with] == URI::MailTo::EMAIL_REGEXP }
            :email
          else
            :text
          end
        end

        def is_password_field?
          key = self.key.to_s.downcase

          exact_matches = ["password"]
          prefixes = ["encrypted_"]
          suffixes = ["_password", "_digest", "_hash"]

          exact_matches.include?(key) ||
            prefixes.any? { |prefix| key.start_with?(prefix) } ||
            suffixes.any? { |suffix| key.end_with?(suffix) }
        end
      end
    end
  end
end
