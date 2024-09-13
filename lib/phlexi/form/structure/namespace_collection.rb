# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class NamespaceCollection < Phlexi::Field::Structure::NamespaceCollection
        def extract_input(params)
          namespace = build_namespace(0)
          @block.call(namespace)

          inputs = params[key].map { |param| namespace.extract_input([param]) }
          {key => inputs}
        end
      end
    end
  end
end
