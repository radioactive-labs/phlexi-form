# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Step
        def step(value = nil)
          if value.nil?
            options.fetch(:step) { options[:step] = calculate_step }
          else
            options[:step] = value
            self
          end
        end

        private

        def calculate_step
          if (scale = get_scale_from_attribute(key))
            return 1.fdiv(10**scale)
          end

          case inferred_field_type
          when :integer
            1
          when :decimal, :float
            "any"
          end
        end

        def get_scale_from_attribute(attribute)
          if object.class.respond_to?(:attribute_types) && (attribute_type = object.class.attribute_types[attribute.to_s])
            attribute_type.scale if attribute_type.respond_to?(:scale)
          end
        end
      end
    end
  end
end
