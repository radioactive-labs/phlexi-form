# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Labels
        def label(label = nil)
          if label.nil?
            options[:label] = options.fetch(:label) { calculate_label }
          else
            options[:label] = label
            self
          end
        end

        private

        def calculate_label
          if object.class.respond_to?(:human_attribute_name)
            object.class.human_attribute_name(key.to_s, {base: object})
          else
            key.to_s.humanize
          end
        end
      end
    end
  end
end
