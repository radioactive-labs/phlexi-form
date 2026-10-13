# frozen_string_literal: true

module Phlexi
  module Form
    module Options
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

        def can_show_errors?
          options[:error] != false
        end

        def show_errors?
          can_show_errors? && has_errors?
        end

        def valid?
          !has_errors? && has_value?
        end

        # Determines if the associated object is in a valid state
        #
        # An object is considered valid if it is persisted and has no errors.
        #
        # @return [Boolean] true if the object is persisted and has no errors, false otherwise
        def object_valid?
          object.respond_to?(:persisted?) && object.persisted? &&
            object.respond_to?(:errors) && !object.errors.empty?
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
          full_messages_for(key)
        end

        def errors_on_association
          association_reflection ? object.errors[association_reflection.name] : []
        end

        def full_errors_on_association
          association_reflection ? full_messages_for(association_reflection.name) : []
        end

        # ActiveModel names the attribute with human_attribute_name. A field
        # given its own label names it as the form shows it, so the message
        # under the field matches the label above it.
        def full_messages_for(attribute)
          return object.errors.full_messages_for(attribute) unless custom_label?

          format, *defaults = full_message_formats(attribute)
          object.errors.messages_for(attribute).map do |message|
            I18n.t(format, default: defaults, attribute: label, message: message)
          end
        end

        # The format keys ActiveModel::Error.full_message looks up, so per-model
        # and per-attribute formats still apply when the label is swapped in.
        def full_message_formats(attribute)
          formats = []
          if ActiveModel::Error.i18n_customize_full_message && object.class.respond_to?(:i18n_scope)
            scope = "#{object.class.i18n_scope}.errors.models"
            formats = object.class.lookup_ancestors.flat_map do |klass|
              [
                :"#{scope}.#{klass.model_name.i18n_key}.attributes.#{attribute}.format",
                :"#{scope}.#{klass.model_name.i18n_key}.format"
              ]
            end
          end
          formats + [:"errors.format", "%{attribute} %{message}"]
        end

        def custom_label?
          label.present? && label != calculate_label
        end

        def has_custom_error?
          options[:error].is_a?(String)
        end
      end
    end
  end
end
