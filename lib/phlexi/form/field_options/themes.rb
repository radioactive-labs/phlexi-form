# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Themes
        # Resolves theme classes for components based on their type and the validity state of the field.
        #
        # This method is responsible for determining the appropriate CSS classes for a given form component.
        # It considers both the base theme for the component type and any additional theming based on the
        # component's validity state (valid, invalid, or neutral). The method supports a hierarchical
        # theming system, allowing for cascading themes and easy customization.
        #
        # @param component [Symbol, String] The type of form component (e.g., :input, :label, :wrapper)
        #
        # @return [String, nil] A string of CSS classes for the component, or nil if no theme is applied
        #
        # @example Basic usage
        #   themed(:input)
        #   # => "w-full p-2 border rounded-md shadow-sm font-medium text-sm dark:bg-gray-700"
        #
        # @example Usage with validity state
        #   # Assuming the field has errors
        #   themed(:input)
        #   # => "w-full p-2 border rounded-md shadow-sm font-medium text-sm dark:bg-gray-700 bg-red-50 border-red-500 text-red-900"
        #
        # @example Cascading themes
        #   # Assuming textarea inherits from input in the theme definition
        #   themed(:textarea)
        #   # => "w-full p-2 border rounded-md shadow-sm font-medium text-sm dark:bg-gray-700"
        #
        # @note The actual CSS classes returned will depend on the theme definitions in the `theme` hash
        #       and any overrides specified in the `options` hash.
        #
        # @see #resolve_theme
        # @see #resolve_validity_theme
        # @see #theme
        def themed(component)
          return unless component

          tokens(resolve_theme(component), resolve_validity_theme(component)).presence
        end

        protected

        # Recursively resolves the theme for a given property, handling nested symbol references
        #
        # @param property [Symbol, String] The theme property to resolve
        # @param visited [Set] Set of already visited properties to prevent infinite recursion
        # @return [String, nil] The resolved theme value or nil if not found
        #
        # @example Resolving a nested theme
        #   # Assuming the theme is: { input: :base_input, base_input: "some-class" }
        #   resolve_theme(:input)
        #   # => "some-class"
        def resolve_theme(property, visited = Set.new)
          return nil if !property.present? || visited.include?(property)
          visited.add(property)

          result = theme[property]
          if result.is_a?(Symbol)
            resolve_theme(result, visited)
          else
            result
          end
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
        def resolve_validity_theme(property)
          validity_property = if has_errors?
            :"invalid_#{property}"
          elsif object_valid?
            :"valid_#{property}"
          else
            :"neutral_#{property}"
          end

          resolve_theme(validity_property)
        end

        # Retrieves or initializes the theme hash for the form builder.
        #
        # This method returns a hash containing theme definitions for various form components.
        # If a theme has been explicitly set in the options, it returns that. Otherwise, it
        # initializes and returns a default theme.
        #
        # The theme hash defines CSS classes or references to other theme keys for different
        # components and their states (e.g., valid, invalid, neutral).
        #
        # @return [Hash] A hash containing theme definitions for form components
        #
        # @example Accessing the theme
        #   theme[:input]
        #   # => "w-full p-2 border rounded-md shadow-sm font-medium text-sm dark:bg-gray-700"
        #
        # @example Accessing a validity-specific theme
        #   theme[:invalid_input]
        #   # => "bg-red-50 border-red-500 text-red-900 placeholder-red-700 focus:ring-red-500 focus:border-red-500"
        #
        # @example Theme inheritance
        #   theme[:textarea] # Returns :input, indicating textarea inherits input's theme
        #   theme[:valid_textarea] # Returns :valid_input
        #
        # @note The actual content of the theme hash depends on the default_theme method
        #       and any theme overrides specified in the options when initializing the field builder.
        #
        # @see #default_theme
        def theme
          @theme ||= options[:theme] || default_theme
        end

        # Defines and returns the default theme hash for the field builder.
        #
        # This method returns a hash containing the base theme definitions for various components.
        # It sets up the default styling and relationships between different components and their states.
        # The theme uses a combination of explicit CSS classes and symbolic references to other theme keys,
        # allowing for a flexible and inheritance-based theming system.
        #
        # @return [Hash] A frozen hash containing default theme definitions for components
        #
        # @example Accessing the default theme
        #   default_theme[:input]
        #   # => nil (indicates that :input doesn't have a default and should be defined by the user)
        #
        # @example Theme inheritance
        #   default_theme[:textarea]
        #   # => :input (indicates that :textarea inherits from :input)
        #
        # @example Validity state theming
        #   default_theme[:valid_textarea]
        #   # => :valid_input (indicates that :valid_textarea inherits from :valid_input)
        #
        # @note This method returns a frozen hash to prevent accidental modifications.
        #       To customize the theme, users should provide their own theme hash when initializing the field builder.
        # @note Most theme values are set to nil or commented out in the default theme to encourage users
        #       to define their own styles while maintaining the relationships between components and states.
        #
        # @see #theme
        def default_theme
          {
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

            # # label themes
            # label: "md:w-1/6 mt-2 block mb-2 text-sm font-medium",
            # invalid_label: "text-red-700 dark:text-red-500",
            # valid_label: "text-green-700 dark:text-green-500",
            # neutral_label: "text-gray-700 dark:text-white",
            # # input themes
            # input: "w-full p-2 border rounded-md shadow-sm font-medium text-sm dark:bg-gray-700",
            # invalid_input: "bg-red-50 border-red-500 dark:border-red-500 text-red-900 dark:text-red-500 placeholder-red-700 dark:placeholder-red-500 focus:ring-red-500 focus:border-red-500",
            # valid_input: "bg-green-50 border-green-500 dark:border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500",
            # neutral_input: "border-gray-300 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white focus:ring-primary-500 focus:border-primary-500",
            # # hint themes
            # hint: "mt-2 text-sm text-gray-500 dark:text-gray-200",
            # # error themes
            # error: "mt-2 text-sm text-red-600 dark:text-red-500",
            # # wrapper themes
            # wrapper: "flex flex-col md:flex-row items-start space-y-2 md:space-y-0 md:space-x-2 mb-4",
            # inner_wrapper: "md:w-5/6 w-full",
          }.freeze
        end
      end
    end
  end
end
