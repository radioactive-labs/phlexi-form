# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class RadioButton < Input
        def view_template
          input(**attributes, value: @checked_value)
        end

        def extract_input(...)
          # when a radio is not submitted, nothing is returned
          super.compact
        end

        protected

        def build_input_attributes
          attributes[:type] = :radio
          super

          @checked_value = (attributes.key?(:checked_value) ? attributes.delete(:checked_value) : "1").to_s

          # this is a hack to workaround the fact that radio cannot be indexed/multiple
          attributes[:name] = attributes[:name].sub(/\[\]$/, "")
          attributes[:value] = @checked_value
          attributes[:checked] = attributes.fetch(:checked) { checked? }
        end

        def checked?
          field.dom.value == @checked_value
        end

        def normalize_input(...)
          input_value = super
          (input_value == @checked_value) ? input_value : nil
        end
      end
    end
  end
end
