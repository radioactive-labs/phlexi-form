# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Errors
        def custom_error(error)
          options[:error] = error
          self
        end

        def error
          error_text if has_errors?
        end

        def full_error
          full_error_text if has_errors?
        end

        def has_errors?
          object_with_errors? || !object && has_custom_error?
        end

        def show_errors?
          options[:error] != false
        end

        def valid?
          !has_errors? && has_value?
        end

        protected

        def error_text
          text = has_custom_error? ? options[:error] : errors.send(error_method)

          "#{options[:error_prefix]} #{text}".lstrip
        end

        def full_error_text
          has_custom_error? ? options[:error] : full_errors.send(error_method)
        end

        def object_with_errors?
          object&.respond_to?(:errors) && errors.present?
        end

        def error_method
          options[:error_method] || :first
        end

        def errors
          @errors ||= (errors_on_attribute + errors_on_association).compact
        end

        def full_errors
          @full_errors ||= (full_errors_on_attribute + full_errors_on_association).compact
        end

        def errors_on_attribute
          object.errors[key] || []
        end

        def full_errors_on_attribute
          object.errors.full_messages_for(key)
        end

        def errors_on_association
          reflection ? object.errors[reflection.name] : []
        end

        def full_errors_on_association
          reflection ? object.errors.full_messages_for(reflection.name) : []
        end

        def has_custom_error?
          options[:error].is_a?(String)
        end
      end
    end
  end
end
