# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Hints
        def hint(hint = nil)
          if hint.nil?
            options[:hint]
          else
            options[:hint] = hint
            self
          end
        end

        def has_hint?
          options[:hint] != false && hint.present?
        end
      end
    end
  end
end
