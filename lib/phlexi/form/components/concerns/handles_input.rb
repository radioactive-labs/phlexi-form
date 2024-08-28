# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module HandlesInput
          include Phlexi::Form::Components::Concerns::ExtractsInput

          protected

          def build_attributes
            super

            # only overwrite id if it was set in Base
            attributes[:id] = field.dom.id if attributes[:id] == "#{field.dom.id}_#{component_name}"
            attributes[:name] = field.dom.name
          end
        end
      end
    end
  end
end
