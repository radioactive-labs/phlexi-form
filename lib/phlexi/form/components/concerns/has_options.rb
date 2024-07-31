# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module HasOptions
          protected

          def build_attributes
            super
            @collection = attributes.delete(:collection) || field.collection
            @label_method = attributes.delete(:label_method)
            @value_method = attributes.delete(:value_method)
          end

          def option_mapper
            @option_mapper ||= OptionMapper.new(@collection, label_method: @label_method, value_method: @value_method)
          end

          def selected?(option)
            if field.multiple?
              @options_list ||= Array(field.value)
              @options_list.any? { |item| item.to_s == option.to_s }
            else
              field.dom.value == option.to_s
            end
          end
        end
      end
    end
  end
end
