# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class AssociationBase < Select
        protected

        delegate :association_reflection, to: :field

        def build_association_attributes
          raise NotImplementedError, "#{self.class}#build_association_attributes"
        end

        def choices
          raise NotImplementedError, "#{self.class}#choices"
        end

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

        def choices_from_association(klass)
          relation = klass.all

          if association_reflection.respond_to?(:scope) && association_reflection.scope
            relation = if association_reflection.scope.parameters.any?
              association_reflection.klass.instance_exec(object, &association_reflection.scope)
            else
              association_reflection.klass.instance_exec(&association_reflection.scope)
            end
          else
            order = association_reflection.options[:order]
            conditions = association_reflection.options[:conditions]
            conditions = object.instance_exec(&conditions) if conditions.respond_to?(:call)

            relation = relation.where(conditions) if relation.respond_to?(:where) && conditions.present?
            relation = relation.order(order) if relation.respond_to?(:order)
          end

          relation
        end
      end
    end
  end
end
