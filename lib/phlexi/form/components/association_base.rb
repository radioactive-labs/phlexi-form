# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class AssociationBase < Select
        protected

        delegate :association_reflection, to: :field

        def selected?(option)
          case association_reflection.macro
          when :belongs_to, :has_one
            singular_field_value.to_s == option.to_s
          when :has_many, :has_and_belongs_to_many
            collection_field_value.any? { |item| item.to_s == option.to_s }
          end
        end

        def singular_field_value
          @singular_field_value ||= field.value&.public_send(association_reflection.klass.primary_key)
        end

        def collection_field_value
          @collection_field_value ||= field.value&.map { |v| v.public_send(association_reflection.klass.primary_key) }
        end

        def build_attributes
          build_association_attributes
          super
        end

        def build_association_attributes
          raise NotImplementedError, "#{self.class}#build_association_attributes"
        end
      end
    end
  end
end
