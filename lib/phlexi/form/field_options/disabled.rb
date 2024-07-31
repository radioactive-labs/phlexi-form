# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Disabled
        def disabled?
          options[:disabled] == true
        end

        def disabled!(disabled = true)
          options[:disabled] = disabled
          self
        end
      end
    end
  end
end
