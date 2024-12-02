# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class HasMany < Select
        protected

        delegate :association_reflection, to: :field

        def build_attributes
          super

          build_has_many_attributes
        end

        def build_has_many_attributes
          attributes.fetch(:input_param) {
            attributes[:input_param] = :"#{association_reflection.name.to_s.singularize}_ids"
          }
        end
      end
    end
  end
end
