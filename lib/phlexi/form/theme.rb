module Phlexi
  module Form
    class Theme < Phlexi::Field::Theme
      def self.theme
        @theme ||= {
          # == Base
          base: nil,
          hint: nil,
          error: nil,
          full_error: :error,
          wrapper: nil,
          inner_wrapper: nil,
          button: nil,
          submit_button: :button,

          # == Errors
          form_errors_wrapper: nil,
          form_errors_message: nil,
          form_errors_list: nil,

          # == Label
          label: nil,
          invalid_label: nil,
          valid_label: nil,
          neutral_label: nil,

          # == Input
          input: nil,
          valid_input: nil,
          invalid_input: nil,
          neutral_input: nil,

          # String
          string: :input,
          valid_string: :valid_input,
          invalid_string: :invalid_input,
          neutral_string: :neutral_input,

          # Email
          email: :input,
          valid_email: :valid_input,
          invalid_email: :invalid_input,
          neutral_email: :neutral_input,

          # Password
          password: :input,
          valid_password: :valid_input,
          invalid_password: :invalid_input,
          neutral_password: :neutral_input,

          # Phone
          phone: :input,
          valid_phone: :valid_input,
          invalid_phone: :invalid_input,
          neutral_phone: :neutral_input,

          # Color
          color: :input,
          valid_color: :valid_input,
          invalid_color: :invalid_input,
          neutral_color: :neutral_input,

          # Url
          url: :input,
          valid_url: :valid_input,
          invalid_url: :invalid_input,
          neutral_url: :neutral_input,

          # Search
          search: :input,
          valid_search: :valid_input,
          invalid_search: :invalid_input,
          neutral_search: :neutral_input,

          # Number
          number: :input,
          valid_number: :valid_input,
          invalid_number: :invalid_input,
          neutral_number: :neutral_input,

          # Date
          date: :input,
          valid_date: :valid_input,
          invalid_date: :invalid_input,
          neutral_date: :neutral_input,

          # Time
          time: :input,
          valid_time: :valid_input,
          invalid_time: :invalid_input,
          neutral_time: :neutral_input,

          # DateTime
          datetime: :input,
          valid_datetime: :valid_input,
          invalid_datetime: :invalid_input,
          neutral_datetime: :neutral_input,

          # Checkbox
          checkbox: :input,
          valid_checkbox: :valid_input,
          invalid_checkbox: :invalid_input,
          neutral_checkbox: :neutral_input,

          # Boolean
          boolan: :checkbox,
          valid_boolan: :valid_checkbox,
          invalid_boolan: :invalid_checkbox,
          neutral_boolan: :neutral_checkbox,

          # Textarea
          textarea: :input,
          valid_textarea: :valid_input,
          invalid_textarea: :invalid_input,
          neutral_textarea: :neutral_input,

          # Hstore
          hstore: :textarea,
          valid_hstore: :valid_textarea,
          invalid_hstore: :invalid_textarea,
          neutral_hstore: :neutral_textarea,

          # Select
          select: :input,
          valid_select: :valid_input,
          invalid_select: :invalid_input,
          neutral_select: :neutral_input,

          # File
          file: :input,
          valid_file: :valid_input,
          invalid_file: :invalid_input,
          neutral_file: :neutral_input,

          # BelongsTo
          belongs_to: :select,
          valid_belongs_to: :valid_select,
          invalid_belongs_to: :invalid_select,
          neutral_belongs_to: :neutral_select,

          # HasMany
          has_many: :select,
          valid_has_many: :valid_select,
          invalid_has_many: :invalid_select,
          neutral_has_many: :neutral_select

        }.freeze
      end

      # Resolves the theme for a component based on its current validity state
      #
      # This method determines the validity state of the field (valid, invalid, or neutral)
      # and returns the corresponding theme by prepending the state to the component name.
      #
      # @param property [Symbol, String] The base theme property to resolve
      # @return [String, nil] The resolved validity-specific theme or nil if not found
      #
      # @example Resolving a validity theme
      #   # Assuming the field has errors and the theme includes { invalid_input: "error-class" }
      #   resolve_validity_theme(:input)
      #   # => "error-class"
      def resolve_validity_theme(property, field)
        return unless field

        validity_property = if field.has_errors?
          :"invalid_#{property}"
        elsif field.object_valid?
          :"valid_#{property}"
        else
          :"neutral_#{property}"
        end

        resolve_theme(validity_property)
      end
    end
  end
end
