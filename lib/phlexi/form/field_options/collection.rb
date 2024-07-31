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
          if has_validators?
            inclusion_validator = find_inclusion_validator
            collection_value_from(inclusion_validator)
          end
        end

        def collection_value_from(inclusion_validator)
          if inclusion_validator
            inclusion_validator.options[:in] || inclusion_validator.options[:within]
          end
        end

        def find_inclusion_validator
          find_validator(:inclusion)
        end
      end
    end
  end
end
