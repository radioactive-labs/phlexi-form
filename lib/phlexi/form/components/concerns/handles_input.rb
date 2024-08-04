# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module HandlesInput
          # Collects parameters matching the input field's param key.
          #
          # @param params [Hash] the parameters to collect from.
          # @return [Hash] the collected parameters.
          def extract_input(params)
            # # Handles multi parameter attributes
            # # https://www.cookieshq.co.uk/posts/rails-spelunking-date-select
            # # https://www.cookieshq.co.uk/posts/multiparameter-attributes

            # # Matches
            # # - parameter
            # # - parameter(1)
            # # - parameter(2)
            # # - parameter(1i)
            # # - parameter(2f)
            # regex = /^#{param}(\(\d+[if]?\))?$/
            # keys = params.select { |key, _| regex.match?(key) }.keys
            # params.slice(*keys)

            params ||= {}
            {input_param => normalize_input(params[field.key])}
          end

          protected

          def build_attributes
            super
            @input_param = attributes.delete(:input_param) || field.key
          end

          def input_param
            @input_param
          end

          def normalize_input(input_value)
            normalize_simple_input(input_value)
          end

          def normalize_simple_input(input_value)
            input_value.to_s.presence
          end
        end
      end
    end
  end
end
