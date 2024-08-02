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
            normalize_input(params&.slice(param_key).presence || {param_key => nil})
          end

          protected

          def param_key
            field.key
          end

          def normalize_input(input_hash)
            input_hash.transform_values{ |value| normalize_input_value(value) }
          end

          def normalize_input_value(input_value)
            input_value.to_s.presence
          end
        end
      end
    end
  end
end
