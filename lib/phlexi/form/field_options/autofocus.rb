# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Autofocus
        def focused?
          options[:autofocus] == true
        end

        def focused!(autofocus = true)
          options[:autofocus] = autofocus
          self
        end
      end
    end
  end
end
