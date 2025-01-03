# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class BelongsTo < AssociationBase
        protected

        def build_association_attributes
          attributes.fetch(:input_param) do
            attributes[:input_param] = if association_reflection.respond_to?(:options) && association_reflection.options[:foreign_key]
              association_reflection.options[:foreign_key]
            else
              :"#{association_reflection.name}_id"
            end
          end
        end
      end
    end
  end
end
