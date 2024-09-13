module Phlexi
  module Form
    class Theme < Phlexi::Field::Theme
      def self.theme
        @theme ||= {
          base: nil,

          # # input
          # input: nil,
          # valid_input: nil,
          # invalid_input: nil,
          # neutral_input: nil,

          # textarea
          textarea: :input,
          valid_textarea: :valid_input,
          invalid_textarea: :invalid_input,
          neutral_textarea: :neutral_input,

          # select
          select: :input,
          valid_select: :valid_input,
          invalid_select: :invalid_input,
          neutral_select: :neutral_input,

          # file
          file: :input,
          valid_file: :valid_input,
          invalid_file: :invalid_input,
          neutral_file: :neutral_input,

          # misc
          # label: nil,
          # hint: nil,
          # error: nil,
          full_error: :error,
          # wrapper: nil,
          # inner_wrapper: nil,
          submit_button: :button
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
