# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Collection
        def collection(collection = nil)
          if collection.nil?
            options.fetch(:collection) { options[:collection] = infer_collection }
          else
            options[:collection] = collection
            self
          end
        end

        private

        def infer_collection
          if object.class.respond_to?(:defined_enums)
            return object.class.defined_enums.fetch(key.to_s).keys if object.class.defined_enums.key?(key.to_s)
          end

          collection_value_from_association || collection_value_from_validator
        end

        def collection_value_from_association
          return unless association_reflection

          relation = association_reflection.klass.all

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

        def collection_value_from_validator
          return unless has_validators?

          inclusion_validator = find_validator(:inclusion)
          inclusion_validator.options[:in] || inclusion_validator.options[:within] if inclusion_validator
        end
      end
    end
  end
end
