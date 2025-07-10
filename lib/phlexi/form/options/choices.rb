# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Choices
        def choices(choices = nil)
          if choices.nil?
            options.fetch(:choices) { options[:choices] = infer_choices }
          else
            options[:choices] = choices
            self
          end
        end

        private

        def infer_choices
          if object.class.respond_to?(:defined_enums)
            return object.class.defined_enums.fetch(key.to_s).keys.map { |k| [k.humanize, k] } if object.class.defined_enums.key?(key.to_s)
          end

          choices_from_validator
        end

        def choices_from_validator
          return unless has_validators?

          inclusion_validator = find_validator(:inclusion)
          inclusion_validator.options[:in] || inclusion_validator.options[:within] if inclusion_validator
        end
      end
    end
  end
end
