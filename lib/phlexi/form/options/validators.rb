# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Validators
        private

        def find_numericality_validator
          find_validator(:numericality)
        end

        def evaluate_numericality_validator_option(option)
          case option
          when Proc
            option.arity.zero? ? option.call : option.call(object)
          else
            option
          end
        end
      end
    end
  end
end
