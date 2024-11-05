# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class NamespaceCollection < Phlexi::Field::Structure::NamespaceCollection
        include Phlexi::Form::Structure::ManagesFields
        
        def extract_input(params)
          namespace = build_namespace(0)
          @block.call(namespace)

          params = params[key]
          params = params.values if params.is_a?(Hash)
          inputs = params.map { |param| namespace.extract_input([param]) }
          {key => inputs}
        end
      end
    end
  end
end
