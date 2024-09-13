# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Validators
        private

        def has_validators?
          @has_validators ||= object.class.respond_to?(:validators_on)
        end

        def attribute_validators
          object.class.validators_on(key)
        end

        def association_reflection_validators
          association_reflection ? object.class.validators_on(association_reflection.name) : []
        end

        def valid_validator?(validator)
          !conditional_validators?(validator) && action_validator_match?(validator)
        end

        def conditional_validators?(validator)
          validator.options.include?(:if) || validator.options.include?(:unless)
        end

        def action_validator_match?(validator)
          return true unless validator.options.include?(:on)

          case validator.options[:on]
          when :save
            true
          when :create
            !object.persisted?
          when :update
            object.persisted?
          end
        end

        def find_validator(kind)
          attribute_validators.find { |v| v.kind == kind && valid_validator?(v) } if has_validators?
        end
      end
    end
  end
end
