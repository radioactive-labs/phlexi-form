# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Placeholder
        def placeholder(placeholder = nil)
          if placeholder.nil?
            options[:placeholder]
          else
            options[:placeholder] = placeholder
            self
          end
        end
      end
    end
  end
end
