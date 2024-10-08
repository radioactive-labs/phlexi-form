# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class SubmitButton < Base
        include Concerns::SubmitsForm

        def view_template(&content)
          content ||= proc { submit_type_label }
          button(**attributes, &content)
        end

        protected

        def build_attributes
          root_key = field.dom.lineage.first.respond_to?(:dom_id) ? field.dom.lineage.first.dom_id : field.dom.lineage.first.key
          attributes.fetch(:id) { attributes[:id] = "#{root_key}_submit_button" }
          attributes[:class] = tokens(
            component_name,
            submit_type_value,
            attributes[:class]
          )

          build_button_attributes
        end

        def build_button_attributes
          formmethod = attributes[:formmethod]
          if formmethod.present? && !/post|get/i.match?(formmethod) && !attributes.key?(:name) && !attributes.key?(:value)
            attributes.merge! formmethod: :post, name: "_method", value: formmethod
          end

          attributes.fetch(:name) { attributes[:name] = "commit" }
          attributes.fetch(:value) { attributes[:value] = submit_type_label }
          attributes.fetch(:type) { attributes[:type] = :submit }
        end
      end
    end
  end
end
