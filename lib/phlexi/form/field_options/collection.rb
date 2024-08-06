# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Collection
        def collection(collection = nil)
          if collection.nil?
            options[:collection] = options.fetch(:collection) { infer_collection }
          else
            options[:collection] = collection
            self
          end
        end

        private

        def infer_collection
          collection_value_from_association || collection_value_from_validator
        end

        def collection_value_from_association
          return unless reflection

          relation = reflection.klass.all

          if reflection.respond_to?(:scope) && reflection.scope
            relation = if reflection.scope.parameters.any?
              reflection.klass.instance_exec(object, &reflection.scope)
            else
              reflection.klass.instance_exec(&reflection.scope)
            end
          else
            order = reflection.options[:order]
            conditions = reflection.options[:conditions]
            conditions = object.instance_exec(&conditions) if conditions.respond_to?(:call)

            relation = relation.where(conditions) if relation.respond_to?(:where) && conditions.present?
            relation = relation.order(order) if relation.respond_to?(:order)
          end

          relation
        end

        def collection_value_from_validator
          return unless has_validators?

          inclusion_validator = find_validator(:inclusion)
          inclusion_validator.options[:in] || inclusion_validator.options[:within] if inclusion_validator
        end
      end
    end
  end
end
