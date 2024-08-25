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
          hint.present?
        end

        def show_hint?
          has_hint? && !show_errors?
        end
      end
    end
  end
end
