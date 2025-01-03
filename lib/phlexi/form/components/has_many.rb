# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class HasMany < AssociationBase
        protected

        def build_association_attributes
          attributes.fetch(:input_param) {
            attributes[:input_param] = :"#{association_reflection.name.to_s.singularize}_ids"
          }
          attributes[:multiple] = true
        end
      end
    end
  end
end
